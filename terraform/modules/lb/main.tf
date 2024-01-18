resource "aws_lb" "main_elb" {
  internal = false
  load_balancer_type = "application"
  security_groups = [var.security_group_id]
  subnets = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "ARINF_main_lb"
  }
}

resource "aws_lb_target_group" "main_lb_tg" {
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = var.vpc_id
  depends_on = [ aws_lb.main_elb ]

  tags = {
    Name = "ARINF_main_lb_tg"
  }
}

resource "aws_lb_listener" "main_lb_listener" {
  load_balancer_arn = aws_lb.main_elb.arn
  port = 443
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.main_lb_tg.arn
    type = "forward"
  }
}

resource "aws_launch_template" "main_lt" {
  name = "main_lt"
  image_id = var.image_id
  instance_type = "t2.micro"
  //key_name = var.key_name
  user_data = filebase64(("../instance_init.sh"))

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [var.security_group_id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      name = "ARINF_main_lt"
    }
  }
  
}

resource "aws_autoscaling_group" "main_asg" {
  name = "main_asg"
  max_size = 4
  min_size = 2
  desired_capacity = 2
  health_check_grace_period = 300
  health_check_type = "ELB"
  vpc_zone_identifier = var.subnet_ids
  target_group_arns = []

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id = aws_launch_template.main_lt.id
    version = "$Latest"
  }
  depends_on = [aws_lb.main_elb]
}


# scale up policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "main-asg-scale-up"
  autoscaling_group_name = aws_autoscaling_group.main_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" #increasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# scale up alarm
# alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "main-asg-scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30" # New instance will be created once CPU utilization is higher than 30 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.main_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}

# scale down policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "main-asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.main_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decreasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "main-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5" # Instance will scale down when CPU utilization is lower than 5 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.main_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}