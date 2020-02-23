provider "aws" {
  region = "ap-southeast-1"
}

//Create elastic load balancer 
resource "aws_elb" "elb" {
  name = "elb"
  instances = ["${var.instance1_id}","${var.instance2_id}"]
  subnets =["${var.public_subnet1}","${var.public_subnet2}"]
  security_groups = ["${aws_security_group.elb_sg.id}"]
  cross_zone_load_balancing = true 
  idle_timeout = 300
  connection_draining = true
  connection_draining_timeout = 300

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }
  tags = {
    Name = "WordPress"
  }
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
