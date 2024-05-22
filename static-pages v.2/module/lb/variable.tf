variable "lb_name" {
    description = "Nombre de LB"
    type        = string
}
variable "server_id" {
    description = "ID de servidores EC2"
    type        = set(string)
}
variable "lb_port" {
    description = "Puertos de LB"
    type        = number

    validation {
      condition     = var.lb_port > 0 && var.lb_port <= 65525
      error_message = "Inserte un puerto valido"
    }
}
variable "lb_type" {
    description = "Tipo de LB"
    type        = string
}
variable "server_port" {
    description = "Puerto de servidores EC2"
    type        = number
}