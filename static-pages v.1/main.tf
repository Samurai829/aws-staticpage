# CONFIGURACION DEL PROVEEDOR USADO POR TERRAFORM
provider "aws" {
    region = var.region
  
}
terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.23.1"
      }
    }

}
