output "instance_ec2" {
    description = "Server de EC2"
    value = [for server in aws_instance.ec2_instance: server.id]
}