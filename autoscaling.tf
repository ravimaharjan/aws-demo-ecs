resource "aws_appautoscaling_target" "ecs-scaling-target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs-scaling-policy" {
  name               = "demo-ecs-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs-scaling-target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs-scaling-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs-scaling-target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 50.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs-scaling-alarm" {
  alarm_name          = "demo-ecs-scaling-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors ECS service level CPU utilization"
  alarm_actions       = [aws_appautoscaling_policy.ecs-scaling-policy.arn]
  dimensions = {
    ServiceName = "${aws_ecs_service.service.name}"
    ClusterName = "${aws_ecs_cluster.cluster.name}"
  }
}
