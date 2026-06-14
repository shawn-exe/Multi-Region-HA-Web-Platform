resource "aws_lb" "app" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [var.alb_security_group_id]
  subnets         = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.name_prefix}-alb"
  }
}

resource "aws_lb_target_group" "app" {
  name     = "${var.name_prefix}-tg"
  port     = var.app_port
  protocol = "HTTP"

  vpc_id = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 5
  }

  tags = {
    Name = "${var.name_prefix}-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.name_prefix}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    var.ec2_security_group_id
  ]

  #iam_instance_profile {
    #name = var.instance_profile_name
  #}

  user_data = base64encode(
    templatefile(
      "${path.module}/userdata.sh",
      {
        aws_region = var.aws_region
      }
    )
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.name_prefix}-ec2"
    }
  }

  tags = {
    Name = "${var.name_prefix}-launch-template"
  }
}

resource "aws_autoscaling_group" "app" {
  name = "${var.name_prefix}-asg"

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.app.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-ec2"
    propagate_at_launch = true
  }
}