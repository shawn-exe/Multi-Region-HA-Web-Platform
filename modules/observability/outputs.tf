output "log_group_name" {
  description = "CloudWatch Log Group name created"
  value       = aws_cloudwatch_log_group.this.name
}

output "dashboard_name" {
  description = "CloudWatch Dashboard name created"
  value       = aws_cloudwatch_dashboard.this.dashboard_name
}
