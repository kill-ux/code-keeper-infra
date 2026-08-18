resource "aws_lb" "cloud_design_alb" {
  name               = "cloud-design-alb-${var.environment}"
  internal           = var.enable_custom_domain
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.enable_custom_domain ? var.private_subnet_ids : var.public_subnet_ids

  tags = { "Name" = "cloud-design-alb-${var.environment}" }
}

resource "aws_lb_target_group" "cloud_design_gateway_tg" {
  name        = "cloud-design-gateway-tg-${var.environment}"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" // the other option is an instance
  deregistration_delay = 5

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200" // status
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = { "Name" = "cloud-design-gateway-tg-${var.environment}" }
}


resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.cloud_design_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cloud_design_gateway_tg.arn
  }

  tags = { "Name" = "cloud-design-http-listener-${var.environment}" }
}