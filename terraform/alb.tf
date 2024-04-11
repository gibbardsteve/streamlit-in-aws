resource "aws_security_group" "test_lb_sg_tf" {
  name        = "test-lb-sg-tf"
  description = "Allow inbound traffic on port 80"

  ingress {
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "test_lb_tf" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.test_lb_sg_tf.id]
  subnets            = data.aws_subnets.default.ids

  enable_deletion_protection = var.lb_delete_protection

}

resource "aws_lb_target_group" "ip_example" {
  name        = "tf-example-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.main.id
}


resource "aws_alb_listener" "app_http" {
  load_balancer_arn = aws_lb.test_lb_tf.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ip_example.arn
    type             = "forward"
  }
}