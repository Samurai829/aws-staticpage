# RECURSOS PARA EC2


# PART 3 - CREACION DE INSTANCIAS Y SECURITY GROUPS
# INSTANCIA EC2 AZ-1
resource "aws_instance" "container_server1" {
    ami                     = var.amis[var.region]
    instance_type           = var.instance_type
    vpc_security_group_ids  = [aws_security_group.sg_private.id]
    key_name                = var.key_pair[var.region]
    user_data               = file("./EC2Packages/package.sh")  # ARCHIVO DE CONFIGURACION DE INSTANCIA
    subnet_id               = data.aws_subnet.publicsubnet_b.id
    # NOMBRE DE INSTANCIA EN EC2
    tags      = {
      Name    = var.instance_name_1
    }
}
# INSTANCIA EC2 AZ-1
resource "aws_instance" "container_server2" {
    ami                     = var.amis[var.region]
    instance_type           = var.instance_type
    vpc_security_group_ids  = [aws_security_group.sg_private.id]
    key_name                = var.key_pair[var.region]
    user_data               = file("./EC2Packages/package.sh")
    subnet_id               = data.aws_subnet.publicsubnet_b.id 
    # NOMBRE DE INSTANCIA EN EC2
    tags      = {
      Name    = var.instance_name_2
  }
}

# SECURITY GROUP DE INSTANCIAS EC2
resource "aws_security_group" "sg_private" {
  name        = "sg_private"
  description = "Permite el trafico entrante y saliente de Instancias"
  vpc_id      = module.vpc.vpc_id
  # NOMBRE DEL SERVIDOR CREADO EN EC2
  tags        = {
    Name      = "sg-private"
  }
  # ACCESO A PUERTOS
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
#    security_groups = [aws_security_group.secgroup_public.id]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
#    security_groups = [aws_security_group.secgroup_public.id]
  }  
}


# PART 4 - CREACION DE LOAD BALANCING Y SECURITY GROUP
# APPLICATION LOAD BALANCER
resource "aws_lb" "alb" {
  load_balancer_type  = "application"
  name                = "container-alb"
  security_groups     = [aws_security_group.secgroup_public.id]
  subnets             = [data.aws_subnet.publicsubnet_a.id, data.aws_subnet.publicsubnet_b.id]
}

# SECURITY GROUP DE ALB
resource "aws_security_group" "secgroup_public" {
  description   = "Permite acceso ALB"
  name          = "secgroup-public"
  vpc_id        = module.vpc.vpc_id
  tags          = {
    Name        = "SecGroup_Public"
  }
  # ACCESO A PUERTOS DESDE EL EXTERIOR
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ACCESO AL PUERTO 8080 DESDE LOS SERVIDORES
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# PART 5 - CREACION DE TARGET GROUP
# TARGET GROUP DE LOAD BALANCER
resource "aws_lb_target_group" "this" {
  name      = "alb-targetgroup"
  port      = 80
  vpc_id    = module.vpc.vpc_id
  protocol  = "HTTPS"
  # HEALTH CHECK
  health_check {
    enabled   = true
    matcher   = "200"
    path      = "/"
    port      = "8080"
    protocol  = "HTTPS"
  }
}

# PART 6 - ATTACHMENT DE INSTANCIAS
resource "aws_lb_target_group_attachment" "server_1" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id = aws_instance.container_server1.id
  port = 8080
}
resource "aws_lb_target_group_attachment" "server_2" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id = aws_instance.container_server1.id
  port = 8080
}

# PART 7 - LISTENER DE ALB
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type = "forward"
  }
}