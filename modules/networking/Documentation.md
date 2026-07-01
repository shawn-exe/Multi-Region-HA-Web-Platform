# Module: Networking

## Purpose

The networking module creates the core AWS network foundation used by the compute, database, cache, and CDN layers. It provisions a VPC, public and private subnets, internet gateway, NAT gateways, route tables, and security groups for application, load balancer, and RDS traffic.

## Resources Created

- aws_vpc.this
- aws_internet_gateway.this
- aws_subnet.public
- aws_subnet.private
- aws_route_table.public
- aws_route_table.private
- aws_route.public_internet
- aws_route.private_nat
- aws_eip.nat
- aws_nat_gateway.this
- aws_security_group.alb
- aws_security_group.app
- aws_security_group.rds

## Inputs

- vpc_cidr: CIDR block for the VPC
- azs: List of availability zones used for subnet creation
- environment: Environment name used in resource naming and tags

## Outputs

- vpc_id: ID of the VPC
- public_subnet_ids: IDs of the public subnets
- private_subnet_ids: IDs of the private subnets
- alb_security_group_id: Security group used by the application load balancer
- app_security_group_id: Security group used by the application tier
- rds_security_group_id: Security group used by the database tier
- nat_gateway_ids: IDs of the NAT gateways

## Design Notes

- The module creates three public and three private subnets to support high availability across three AZs.
- Each private subnet is paired with a dedicated NAT gateway and route table.
- Security groups are intentionally minimal and allow only the necessary ports for ALB, application traffic, and RDS access.

## Dependency Relationship

This module is consumed by the compute, database, cache, and environment-level modules. It provides the networking primitives that those modules rely on.

## Example Usage

```hcl
module "networking" {
  source = "../../modules/networking"

  environment = "prod"
  vpc_cidr    = "10.0.0.0/16"
  azs         = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
```
