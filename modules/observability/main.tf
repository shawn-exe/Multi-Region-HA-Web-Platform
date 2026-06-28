resource "aws_cloudwatch_log_group" "this" {
	name              = var.log_group_name != "" ? var.log_group_name : "/${var.name_prefix}/app"
	retention_in_days = var.retention_in_days

	tags = var.tags
}

resource "aws_cloudwatch_dashboard" "this" {
	dashboard_name = var.dashboard_name != "" ? var.dashboard_name : "${var.name_prefix}-dashboard"
	dashboard_body = var.dashboard_body
}
