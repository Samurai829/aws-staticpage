variable "server" {
    description = "Instancia EC2"

    type        = map(object({
      name      = string,
      subnet_id = string
    }))
}
variable "type" {
    description = "Tipo de instancia"
    type = string
}
variable "ami" {
    description = "AMI de Instancia"
    type = string
}
variable "server_port" {
    description = "Puertos de Instancia"
    type = number

    validation {
      condition = var.server_port > 0 && var.server_port <= 65525
      error_message = "Inserte un puerto valido"
    }
}
variable "keypair" {
    description = "KeyPair de Instancia"
    type = string
}

variable "ec2_user" {
    description = "Instrucciones de Configuracion de Instancia"
    type = string
}
variable "secgroup" {
    description = "Secgroup requerido de LB"
    type = string
}