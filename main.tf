provider "aws" {
  region = "ap-southeast-1"
}
module "vpc" {
  source = "./vpc"
  
}
module "wordpress_server" {
  source = "./ec2"
  vpc_id = "${module.vpc.vpc_id}"
  ami = "ami-05c64f7b4062b0a21"
  instance_type = "t2.micro"
  subnet_id = "${module.vpc.public_subnets}"
}
module "elastic_loadblancer" {
  source = "./elb"
  vpc_id = "${module.vpc.vpc_id}"
}
module "db" {
  source = "./rds"
  vpc_id = "${module.vpc.vpc_id}"
  wordpress_sg = "${module.ec2.wordpress_sg}"
}

