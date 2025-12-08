provider "aws" {
  region = var.region
}

# -----------------------------
# Security Groups
# -----------------------------
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  vpc_id      = var.vpc_id
  description = "Allow HTTP from world to ALB"

  ingress {
    from_port   = 80
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

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  vpc_id      = var.vpc_id
  description = "Allow traffic only from ALB"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------------------
# Launch Template
# -----------------------------
data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    repo_url = var.repo_url
  }
}

resource "aws_launch_template" "lt" {
  name_prefix   = "static-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  user_data = base64encode(data.template_file.user_data.rendered)

  network_interfaces {
    security_groups             = [aws_security_group.ec2_sg.id]
    associate_public_ip_address = true
  }
}

# -----------------------------
# ALB + Target Group + Listener
# -----------------------------
resource "aws_lb" "alb" {
  name               = "static-site-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "tg" {
  name     = "static-site-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# -----------------------------
# Auto Scaling Group
# -----------------------------
resource "aws_autoscaling_group" "asg" {
  name                      = "static-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = var.public_subnets

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]
}
# -----------------------------
# CloudWatch CPU Alarm + SNS
# -----------------------------
resource "aws_sns_topic" "sns" {
  name = "cpu-alarm-topic"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = var.email_address
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "HighCPUAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  alarm_description = "Trigger when CPU > 60%"
  alarm_actions     = [aws_sns_topic.sns.arn]

  dimensions = {}
}