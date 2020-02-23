provider "aws" {
  region = "ap-southeast-1"
}
module "vpc" {
  source = "./vpc"
  vpc_cidr_block = "172.16.0.0/16"
  public_cidr = ["172.16.10.0/24","172.16.20.0/24"]
  private_cidr = ["172.16.30.0/24","172.16.40.0/24"]
}
module "wordpress_server" {
  source = "./ec2"
  vpc_id = "${module.vpc.vpc_id}"
  ami = "ami-0f02b24005e4aec36"
  instance_type = "t2.micro"
  subnet_id = "${module.vpc.public_subnets}"
}
module "elastic_loadblancer" {
  source = "./elb"
  vpc_id = "${module.vpc.vpc_id}"
  instance1_id = "${module.wordpress_server.instance1_id}"
  instance2_id = "${module.wordpress_server.instance2_id}"
  public_subnet1 = "${module.vpc.public_subnet1}"
  public_subnet2 = "${module.vpc.public_subnet2}"
}
module "database" {
  source = "./rds"
  vpc_id = "${module.vpc.vpc_id}"
  wordpress_sg = "${module.wordpress_server.wordpress_sg}"
  private_subnet1 = "${module.vpc.private_subnet1}"
  private_subnet2 = "${module.vpc.private_subnet2}"
  engine = "mysql"
  username = "admin"
  password = "RDS@dmin#2019"
}

