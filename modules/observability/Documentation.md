# Module: Observability

## Purpose

The observability module creates CloudWatch resources for logging and monitoring, including a log group and a basic dashboard.

## Resources Created

- aws_cloudwatch_log_group.this
- aws_cloudwatch_dashboard.this

## Inputs

- name_prefix: Prefix used in resource naming
- dashboard_name: Name of the CloudWatch dashboard
- dashboard_body: JSON definition for the dashboard body
- log_group_name: Name of the log group
- retention_in_days: Log retention period
- tags: Tags applied to the log group

## Outputs

This module does not currently expose outputs.

## Notes

- The module is intentionally lightweight and can be extended with application-specific metrics and alarms.
- The default retention period is 14 days.

## Example Usage

```hcl
module "observability" {
  source = "../../modules/observability"

  name_prefix    = "prod"
  dashboard_name = "prod-app-dashboard"
  dashboard_body = "{\"widgets\":[] }"
  log_group_name = "/prod/app"
}
```
