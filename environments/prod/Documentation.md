# Environment: Production

## Purpose

The production environment is the full multi-region deployment for the platform. It provisions the infrastructure across us-east-1 and us-west-2 and includes CDN, DNS, and WAF features for edge delivery and resilience.

## Region Coverage

- Primary region: us-east-1
- Secondary region: us-west-2

## Resources Provisioned

- Networking module in both regions
- Compute module in both regions
- Database module in the primary region
- Cache module in both regions
- CDN module with CloudFront, ACM certificate, and WAF
- DNS module for Route 53 aliasing
- Observability module in the primary region

## Inputs

- environment: Environment name
- regions: Map of region-specific VPC CIDR blocks and AZ lists
- db_username: Database username
- db_password: Database password
- domain_name: Application domain name
- hosted_zone_id: Route 53 hosted zone ID

## Variable Values

The current tfvars file sets:

- environment = "prod"
- us-east-1 VPC CIDR = 10.0.0.0/16
- us-west-2 VPC CIDR = 10.1.0.0/16
- Database username = postgres
- Domain name = example.com
- Hosted zone ID = Z123456789ABCDEFG

## Backend Configuration

The environment uses S3 remote state with the backend definition in [backend.tf](backend.tf) and [backend.hcl](backend.hcl).

## Deployment Commands

```bash
cd environments/prod
terraform init -backend-config=backend.hcl
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

## Outputs

The environment exposes:

- VPC IDs for both regions
- Public and private subnet IDs for both regions
- ALB DNS names in both regions
- ASG names for both regions
- Database endpoint and port

## Operational Notes

- Production uses a multi-region design with CloudFront failover between regional ALBs.
- The CDN and DNS modules require a real Route 53 zone and a routable domain.
- Replace the example domain and hosted zone values before using the configuration in a real production rollout.
- The example database credentials should be replaced by secrets from a proper secret manager.
