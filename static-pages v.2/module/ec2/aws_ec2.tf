resource "aws_instance" "ec2_instance" {
for_each = var.server

    ami                     = var.ami
    key_name                = var.keypair
    subnet_id               = each.value.subnet_id
    instance_type           = var.type
    vpc_security_group_ids  = aws_security_group.ec2_secgroup.id


    user_data       = var.ec2_user

    tags            = {
      name          = each.value.name
    }
}

resource "aws_security_group" "ec2_secgroup" {
    description = "Secgroup de Instancia EC2"
    name        = "${each.value.name}_secgroup"
    
    tags    = {
      name  = "${each.value.name}_secgroup"
    }
    
    ingress {
        description = "Puertos definido"
        from_port   = var.server_port
        to_port     = var.server_port
        protocol    = "TCP"
        security_groups = [var.secgroup]
    }
    egress {
        description = "Puerto de Acceso"
        from_port   = var.server_port
        to_port     = var.server_port
        protocol    = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}