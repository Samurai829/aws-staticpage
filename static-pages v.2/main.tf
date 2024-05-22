provider "aws" {
    region = var.region
}
terraform {
  required_providers {
    aws         = {
        source  = "hashicorp/aws"
        version = "~> 5.23.1"
    }
  }
}


locals {
  amis      = var.amis[var.region]
  ec2_type  = var.ec2_type
  keypair   = var.keypair
  ec2_port  = var.ec2_port
  lb_port   = var.lb_port
  lb_name   = var.lb_name
}

# MODULO DE LA VPC CON 2 SUBNET PRIVADAS Y 2 SUBNETS PUBLICAS
module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.1.2"

    name = "vpc_website"
    cidr = "10.0.0.0/16"

    azs             = ["${var.region}a","${var.region}b"]
    private_subnets  = ["10.0.1.0/24", "10.0.101.0/24"]
    public_subnets   = ["10.0.2.0/24", "10.0.102.0/24"]

    enable_nat_gateway = true
    enable_vpn_gateway = true

    tags = {
        terraform = "true"
        environment = "dev"
    }
}

# DATA SOURCE DE PRIVATE SUBNETS
data "aws_subnet" "private1" {
    id = aws_subnet.vpc.private_subnets[0].id
}
data "aws_subnet" "private2" {
    id = aws_subnet.vpc.private_subnets[1].id
}
# DATA SOURCE DE PUBLIC SUBNETS
data "aws_subnet" "public1" {
    id = aws_subnet.vpc.public_subnets[0].id  
}
data "aws_subnet" "public2" {
    id = aws_subnet.vpc.public_subnets[1].id
}


# MODULO DE INSTANCIAS DE EC2
module "server" {
    source = "./module/ec2"

    ami         = local.amis
    keypair     = local.keypair
    type        = local.ec2_type
    server_port = local.ec2_port
    secgroup    = [aws_security_group.alb_secgroup.id]
    
    
    server      = {
        
        for id_ec2, data in var.server:
        id_ec2 => {name = data.name, subnet_id = aws_subnet.public_subnet[id_ec2].id}
    }

    ec2_user = file("./packages/configure.sh")
}


# MODULO DE LOAD BALANCER
module "application_lb" {
    source = "./module/lb"

    lb_name    = local.lb_name
    lb_type     = "application"
    server_id   = aws_instance.server.id
    lb_port    = local.lb_port
    server_port = local.ec2_port
}