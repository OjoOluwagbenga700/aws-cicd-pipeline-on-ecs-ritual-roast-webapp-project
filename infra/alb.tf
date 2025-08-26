# Create an Application Load Balancer (ALB) for the e-commerce application
# This ALB is internet-facing (external) and deployed across 2 public subnets
resource "aws_lb" "alb" {
  name                       = "ritual-roast-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = [module.networking.public_subnets[0], module.networking.public_subnets[1]]
  enable_deletion_protection = false
  depends_on                 = [module.networking, aws_security_group.alb_sg]

  tags = {
    Name = "ritual-roast-alb"
  }
}

# Create a target group for the ALB that will route traffic to ECS tasks
# Uses IP target type since ECS tasks have their own IPs
# Health check configured to verify application health every 5 minutes
resource "aws_lb_target_group" "alb_tg" {
  name        = "ritual-roast-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.networking.vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/health.html"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }
  depends_on = [aws_lb.alb]

  lifecycle {
    # amazonq-ignore-next-line
    #create_before_destroy = true
  }
}

resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }

}

