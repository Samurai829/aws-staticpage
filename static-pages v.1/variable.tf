# REGION DE USADA PARA AWS
variable "region" {
    description = "Region AWS para recursos"
    type        = string
    default     = "us-east-1"
}


# CONFIGURACION DE INSTANCIA DE EC2
variable "instance_type" {
    description = "Tipo de Instancia EC2"
    type        = string
    default     = "t2.micro" 
}
variable "amis" {
    description         = "AMIS por region para instancias EC2"
    type                = map(string)
    default   = {
        us-east-1       = "ami-05c13eab67c5d8861"
        us-east-2       = "ami-089c26792dcb1fbd4"
        ca-central-1    = "ami-0e27477e1cba0d324"
    }
}
variable "instance_name_1" {
    description = "Nombre primera Instancia EC2"
    type        = string
    default     = "Container-instance1" 
}
variable "instance_name_2" {
    description = "Nombre segunda Instancia EC2"
    type        = string
    default     = "Container-instance2" 
}
variable "key_pair" {
    description = "KeyPair usada por defecto en cada Region de AWS"
    type        = map(string)
    default     = {
        us-east-1       = "shogun2"
        us-east-2       = "shogun1"
        ca-central-1    = "shogun3"
    }
}