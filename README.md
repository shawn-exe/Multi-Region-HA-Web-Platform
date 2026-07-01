# Terraform Multi-Region HA Platform

This repository provisions a high-availability AWS infrastructure foundation for web applications using Terraform. The stack is organized into reusable modules for networking, compute, database, caching, CDN, DNS, and observability, and it is deployed across separate environment workspaces for staging and production.

## Architecture Overview

The project is designed around a multi-region, layered architecture:

- Networking: VPCs, public/private subnets, internet gateways, NAT gateways, and security groups
- Compute: Application load balancers, target groups, launch templates, and autoscaling groups
- Data: PostgreSQL RDS instances with optional read replicas
- Caching: ElastiCache for Redis
- Edge delivery: CloudFront, WAF, ACM, and Route 53
- Monitoring: CloudWatch log groups and dashboards
- Shared state bootstrap: S3 bucket and DynamoDB lock table for Terraform state management

## Repository Structure

- [environments/prod](environments/prod) - Production deployment configuration
- [environments/staging](environments/staging) - Staging deployment configuration
- [global](global) - Shared bootstrap resources for Terraform state
- [modules](modules) - Reusable infrastructure modules
- [.github/workflows](.github/workflows) - CI/CD workflow placeholders

## Documentation Index

- [modules/networking/Documentation.md](modules/networking/Documentation.md)
- [modules/compute/Documentation.md](modules/compute/Documentation.md)
- [modules/database/Documentation.md](modules/database/Documentation.md)
- [modules/cache/Documentation.md](modules/cache/Documentation.md)
- [modules/cdn/Documentation.md](modules/cdn/Documentation.md)
- [modules/dns/Documentation.md](modules/dns/Documentation.md)
- [modules/observability/Documentation.md](modules/observability/Documentation.md)
- [environments/staging/Documentation.md](environments/staging/Documentation.md)
- [environments/prod/Documentation.md](environments/prod/Documentation.md)

## Prerequisites

Before deploying, ensure you have:

- An AWS account with permissions to create VPCs, EC2, ALB, RDS, ElastiCache, CloudFront, WAF, ACM, Route 53, CloudWatch, S3, DynamoDB, and IAM policies
- Terraform installed locally
- AWS CLI configured with appropriate credentials
- A Route 53 hosted zone and domain name for production CDN/DNS integration

## Bootstrap Shared State Infrastructure

The shared bootstrap resources are defined in [global/bootstrap.tf](global/bootstrap.tf) and [global/iam_ci.tf](global/iam_ci.tf).

Run the following from the repository root:

```bash
cd global
terraform init
terraform apply
```

This creates:

- An S3 bucket for storing Terraform state
- A DynamoDB table for state locking
- An IAM policy document for Terraform state access

## Environment Setup

### Staging

The staging environment deploys the base HA stack in the us-east-1 region.

```bash
cd environments/staging
terraform init -backend-config=backend.hcl
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

### Production

The production environment deploys a multi-region setup across us-east-1 and us-west-2 and includes CDN and DNS resources.

```bash
cd environments/prod
terraform init -backend-config=backend.hcl
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

## Configuration Notes

- The current configuration uses Terraform variables in each environment's tfvars file.
- Database credentials are provided as plain variables in the example configuration; for real deployments, use AWS Secrets Manager or another secret management solution.
- The production environment uses placeholder values for the domain name and hosted zone ID in [environments/prod/terraform.tfvars](environments/prod/terraform.tfvars).
- The compute module uses a simple Nginx-based user data script for initial application hosting.

## Outputs

After deployment, Terraform outputs include:

- VPC and subnet IDs
- Application load balancer DNS names
- Auto Scaling Group names
- Database endpoint and port
- CloudFront distribution details

## Security and Operational Considerations

- Security groups restrict traffic to application and database tiers.
- RDS instances are deployed with encryption enabled.
- CloudFront uses WAF managed rules for common protections.
- State is managed remotely via S3 and DynamoDB.
- The project is a solid baseline for a demo or MVP, but production hardening should include secrets management, stricter IAM boundaries, and more comprehensive monitoring.

## Next Steps

- Replace placeholder domain values with real production values.
- Add CI/CD pipelines for plan and apply workflow enforcement.
- Extend the compute module to deploy your application stack instead of the placeholder Nginx bootstrap.
- Add additional environment-specific policies and tagging standards.
