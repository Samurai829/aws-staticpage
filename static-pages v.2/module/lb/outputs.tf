output "dns_lb" {
    description = "Salida DNS de LB"
    value       = "http://${aws_lb.lb.dns_name}:${var.lb_port}"
  
}