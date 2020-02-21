provider "aws" {
  region = "ap-southeast-1"
}
//Create a security group for elb
resource "aws_security_group" "elb_sg" {
  name = "elb_sg"
  vpc_id = "${var.vpc_id}"
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "elb_security_group"
  }
}
