# PART 1 - CREACION DE VPC

# MODULO PARA VPC
module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "5.1.2"

    name    = "VPC-TEST"
    cidr    = "10.0.0.0/16"

    azs                   = ["us-east-1a","us-east-1b"]
    private_subnets       = ["10.0.1.0/24", "10.0.101.0/24"]
    public_subnets        = ["10.0.2.0/24", "10.0.102.0/24"]

    enable_nat_gateway  = true
    enable_vpn_gateway  = true


    tags        = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# PART 2 - CONSULTA DE SUBNETS Y ZONAS DE DISPONIBILIDAD 

# PRIVATE SUBNETS
data "aws_subnet" "subnet_a" {
  id    = "subnet-0d21496f555b53fe6"
}
data "aws_subnet" "subnet_b" {
  id    = "subnet-0de02173c82316cb6"
}

# PUBLIC SUBNETS
data "aws_subnet" "publicsubnet_a" {
  id    = "subnet-0701d218d16627948"
}
data "aws_subnet" "publicsubnet_b" {
  id    = "subnet-0a0958f6087ab1e22"
}

# LISTADO DE AZ
data "aws_availability_zones" "all_zones" {}
