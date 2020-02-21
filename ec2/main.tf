provider "aws" {
  region = "ap-southeast-1"
}
data "template_file" "boottrap" {
    template_file = "${file("./ec2/boottrap.tpl")}"
}
//Create  WordPress instances
resource "aws_instance" "wordpress_instance" {
    count = 2
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "public_key_Feb2020"
    user_data = "${data.template_file.boottrap.rendered}"
    vpc_security_group_ids = ["${aws_security_group.wordpress_security_group.id}"]
    subnet_id = "${element(var.subnet_id, count.index)}"
    associate_public_ip_address  = true
    tags = {
        Name = "WordPress.${count.index + 1}"
    }
}
//Create a security group for Word Press server
resource "aws_security_group" "wordpress_security_group" {
    name = "wordpress_sg"
    vpc_id = "${var.vpc_id}"
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
