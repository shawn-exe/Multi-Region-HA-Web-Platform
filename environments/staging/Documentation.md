# Environment: Staging

## Purpose

The staging environment provides a deployment target for validating the Terraform infrastructure before changes are promoted to production. The current configuration provisions the core HA components in one AWS region.

## Region Coverage

- Primary region: us-east-1

## Resources Provisioned

- Networking module for VPC, subnets, NAT gateways, and security groups
- Compute module for ALB, target group, and autoscaling group
- Database module for PostgreSQL RDS with a single replica
- Cache module for Redis
- Observability module for CloudWatch log group and dashboard

## Inputs

- environment: Environment name
- regions: Map describing the VPC CIDR and AZs for each region
- db_username: Database username
- db_password: Database password

## Variable Values

The current tfvars file sets:

- environment = "prod"
- VPC CIDR = 10.0.0.0/16
- AZs = us-east-1a, us-east-1b, us-east-1c
- Database username = postgres

## Backend Configuration

The environment uses S3 remote state with the backend definition in [backend.tf](backend.tf) and [backend.hcl](backend.hcl).

## Deployment Commands

```bash
cd environments/staging
terraform init -backend-config=backend.hcl
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

## Outputs

The environment exposes:

- VPC ID
- Public and private subnet IDs
- ALB DNS name
- ASG name
- Database endpoint and port

## Operational Notes

- The staging environment is currently a simplified single-region deployment.
- The database credentials are supplied as plain variables in the example configuration.
- Consider using a separate staging-specific domain or hostnames before using this configuration in a real test environment.
