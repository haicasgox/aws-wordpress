##################################################
#                      VPC                       #
##################################################
provider "aws" {
    region = "ap-southeast-1"
}
//Create data resource for AZ
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
    cidr_block = "${var.vpc_cidr_block}"
    enable_dns_hostnames = true
    enable_dns_support =  true
    tags = {
        Name = "WordPress"
    }
}
//Create public subnets for Word Press server and ELB
resource "aws_subnet" "public_subnet" {
    count = 2
    cidr_block = "${var.public_cidr[count.index]}"
    vpc_id = "${aws_vpc.main.id}"
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
    tags = {
        Name = "Public_subnet.${count.index + 1}"
    }
}
//Create private subnets for DB 
resource "aws_subnet" "private_subnet" {
   count = 2
   cidr_block = "${var.private_cidr[count.index]}"
   vpc_id = "${aws_vpc.main.id}"
   availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
   tags = {
       Name =  "Private_subet.${count.index + 1}"
   }
}
//Create a IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
      Name = "WordPress"
  }
}
//Create a public route table
resource "aws_route_table" "public_route_table" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
    tags = {
        Name = "WordPress"
    }
}
//Define route table association
resource "aws_route_table_association" "public_subnet1_rt_association" {
    count = 2
    subnet_id = "${aws_subnet.public_subnet.*.id[count.index]}"
    route_table_id = "${aws_route_table.public_route_table.id}"
    depends_on = ["aws_route_table.public_route_table","aws_subnet.public_subnet"]
}
//Create a security group for Word Press server
resource "aws_security_group" "wordpress_security_group" {
    name = "wordpress_sg"
    vpc_id = "${aws_vpc.main.id}"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "ssh"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags  = {
        Name = "wordpress_sg"
    }
}






