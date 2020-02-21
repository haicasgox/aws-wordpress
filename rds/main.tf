provider "aws" {
  region = "ap-southeast-1"
}
//Create a security group for RDS
resource "aws_security_group" "db_sg" {
    name  = "db_sg"
    vpc_id = "${var.vpc_id}"

    ingress {
        from_port = 3306
        to_port  = 3306
        protocol = "tcp"
        security_groups = ["${var.wordpress_sg.id}"]
    }
    tags =  {
        Name = "db_security_group"
    }
}

