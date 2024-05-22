variable "region" {
    description = "Region de AWS"
    type = string
}
variable "keypair" {
    description = "KeyPair por Region"
    type = map(string)
    default = {
      us-east-1     = "shogun1"
      us-east-2     = "shogun2"
      ca_central-1  = "shogun3"
    }
  
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
variable "ec2_type" {
    description = "Tipo de Instancia de AWS"
    type = string
    default = "t2.micro"
}
variable "server" {
    description = "Instancia de EC2"
    type = map(object({
      name  = string,
      azs    = string
    }))

/*    default = {
      "server1" = { name = "server1", azs = "${data.aws_subnet.private1.id}"},
      "server2" = { name = "server2", azs = "${data.aws_subnet.private2.id}"}
    }
*/
}
variable "ec2_port" {
    description = "Puerto de Instancia EC2"
    type = number
}


# ALB CONFIGURATION
variable "lb_name" {
    description = "Nombre de LB"
    type = string
}
variable "lb_port" {
    description = "Puerto de LB"
    type = number

    validation {
      condition = var.lb_port > 0 && var.lb_port <= 65525
      error_message = "Inserte un puerto valido"
    }
  
}