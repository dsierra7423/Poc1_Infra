resource "aws_lb" "lb-external" {
  name            = "lb-external"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb-external.id]
}

resource "aws_security_group" "lb-external" {
  name        = "external-alb-security-group"
  vpc_id      = aws_vpc.default.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 3000
    to_port     = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "lb-external-http" {
  load_balancer_arn = aws_lb.lb-external.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "lb-external-front" {
  load_balancer_arn = aws_lb.lb-external.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.ar-smarty.arn

  default_action {
    target_group_arn = aws_lb_target_group.lb-front-app.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "lb-front-app" {
  name        = "front-lb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"
}
