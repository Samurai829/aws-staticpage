resource "aws_lb" "alb" {
    name                =  var.lb_name
    security_groups     = aws_security_group.alb_secgroup.id
    load_balancer_type  = var.lb_type

    subnets             = var.server_id
}
resource "aws_security_group" "lb_secgroup" {
    description = "Secgroup de LB"
    name        = "${var.lb_name}_secgroup"

    tags        = {
        name    = "${var.lb_name}_secgroup"
    } 

    ingress {
        description = "Puerto definido"
        from_port   = var.lb_port
        to_port     = var.lb_port
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "Puerto definido servidor"
        from_port   = var.server_port
        to_port     = var.server_port
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_lb_target_group" "this" {
    name = "${var.lb_name}-targetgroup"
    port = var.lb_port
    vpc_id = data.aws_vpc.default.id
    protocol = "TCP"

    health_check {
      enabled   = true
      matcher   = "200"
      path      = "/"
      port      = var.server_port
      protocol  = "HTTP"
    }
}
# ATTACHMENT PARA SERVIDOR DE EC2
resource "aws_lb_target_group_attachment" "server_attach" {
for_each = var.server_id

    target_group_arn = aws_lb_target_group.this.arn
    target_id        = each.value
    port             = var.server_port 
}
# LISTENER PARA LOAD BALANCING
resource "aws_lb_listener" "this" {
    load_balancer_arn   = aws_lb.alb
    port                = var.lb_port

    default_action {
      target_group_arn  = aws_lb_target_group.this.arn
      type              = "forward"
    }   
}