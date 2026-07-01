# Module: Database

## Purpose

The database module provisions an Amazon RDS PostgreSQL instance for application persistence. It also creates a subnet group and optional read replicas to support read scaling and resilience.

## Resources Created

- aws_db_subnet_group.this
- aws_db_instance.primary
- aws_db_instance.read_replica (optional via replica_count)

## Inputs

- name_prefix: Prefix used in DB resource names
- private_subnet_ids: List of private subnets for the DB subnet group
- db_security_group_id: Security group granted access to RDS
- db_username: Master DB username
- db_password: Master DB password
- db_instance_class: Instance size for the primary DB
- replica_instance_class: Instance size for read replicas
- replica_count: Number of read replicas to create

## Outputs

- db_endpoint: Primary database endpoint
- db_port: Database port
- replica_endpoints: List of read replica endpoints

## Design Notes

- The primary database uses multi-AZ deployment for higher availability.
- Storage is encrypted at rest.
- Read replicas are created in the same region and are currently configured for the same VPC context.
- The module is intended for PostgreSQL version 16.

## Operational Notes

- The database password is sensitive and should be supplied securely.
- The current example uses a plain variable value; production deployments should use AWS Secrets Manager or Vault.
- Deletion protection is not enabled in this module, so follow operational safeguards when changing or deleting the database.

## Example Usage

```hcl
module "database" {
  source = "../../modules/database"

  name_prefix         = "use1"
  private_subnet_ids  = module.networking.private_subnet_ids
  db_security_group_id = module.networking.rds_security_group_id
  db_username         = var.db_username
  db_password         = var.db_password
  replica_count       = 1
}
```
