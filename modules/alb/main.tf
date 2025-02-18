resource  "aws_lb"  "this"  {
  name                  = "alb-${var.vpc_id}"
  internal              = false
  load_balancer_type    = "application"
  security_groups        = [var.security_group_id]
  subnets               = var.subnets
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.target_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  name        = "${var.alb_name}-tg"
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
  }
}

