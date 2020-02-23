provider "aws" {
  region = "ap-southeast-1"
}

//Create DB instance
resource "aws_db_instance" "RDS" {
    name = "RDS instance"
    engine = "${var.engine}"
    engine_version = "8.0.16"
    storage_type = "gp2"
    allocated_storage = 20
    instance_class = "db.t2.micro"
    username = "${var.username}"
    password = "${var.password}"
    vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
    db_subnet_group_name = "${aws_db_subnet_group.db_subnet_group.id}"
}

//Create subnets for DB
resource "aws_db_subnet_group" "db_subnet_group" {
    name = "db_subnet_group"
    description = "DB subnet group"
    subnet_ids = ["${var.private_subnet1}","${var.private_subnet2}"]
    tags = {
        Name = "DB subnet group"
    }
}

//Create a security group for RDS
resource "aws_security_group" "db_sg" {
    name  = "db_sg"
    vpc_id = "${var.vpc_id}"
    ingress {
        from_port = 3306
        to_port  = 3306
        protocol = "tcp"
        security_groups = ["${var.wordpress_sg}"]
    }
    tags =  {
        Name = "db_security_group"
    }
}
