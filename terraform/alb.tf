resource "aws_lb" "ecommerce_alb" {
  name               = "ecommerce-main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

resource "aws_lb_target_group" "user_tg" {
  name     = "user-service-tg"
  port     = 3001
  protocol = "HTTP"
  vpc_id   = aws_vpc.ecommerce_vpc.id

  health_check {
    path = "/health"
  }
}

# (Repeat target groups for products, orders, cart, and frontend)

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ecommerce_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn # Default to frontend visual site
  }
}

resource "aws_lb_listener_rule" "user_routing" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.user_tg.id
  }

  condition {
    path_pattern {
      values = ["/api/user*"]
    }
  }
}
