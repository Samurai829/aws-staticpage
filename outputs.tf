# ZONA DE DISPONIBILIDAD
output "availability_zones" {
    value = [
        "${data.aws_availability_zones.all_zones.names}"
    ]
}


# DNS PUBLICO DE INSTANCIAS DE EC2
output "dns_publica_server_1" {
  description = "DNS Publica del servidor 1"
  value = "${aws_instance.container_server1.private_dns}"
}
output "dns_publica_server_2" {
  description = "DNS Publica del servidor 2"
  value = "${aws_instance.container_server2.private_dns}"
}

# DNS LOAD BALANCER
output "elb_dns" {
    value = "http://${aws_lb.alb.dns_name}"
}
