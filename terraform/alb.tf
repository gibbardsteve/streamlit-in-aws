resource "aws_security_group" "allow_rules_load_balancer" {
  name        = "allow-rules-lb"
  description = "Allow inbound https traffic on port 443 and redirect http traffic from port 80"

  ingress {
    description = "Redirect HTTP to HTTPS"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow inbound traffic on port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "service_lb" {
  name               = "service-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_rules_load_balancer.id]
  subnets            = data.aws_subnets.default.ids

  enable_deletion_protection = var.lb_delete_protection

}

resource "aws_lb_target_group" "fargate_tg" {
  name        = "fargate-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.main.id
}


resource "aws_lb_listener" "app_https" {
  load_balancer_arn = aws_lb.service_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    target_group_arn = aws_lb_target_group.fargate_tg.arn
    type             = "forward"

  }

  # Can only use a validated certificate 
  depends_on = [aws_acm_certificate_validation.cert]
}

resource "aws_alb_listener" "app_http" {
  load_balancer_arn = aws_lb.service_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      status_code = "HTTP_301"
      protocol    = "HTTPS"
    }
  }

}