# Module: Cache

## Purpose

The cache module provisions an ElastiCache for Redis cluster that can be used by the application tier to reduce database load and improve latency.

## Resources Created

- aws_elasticache_subnet_group.this
- aws_elasticache_cluster.this

## Inputs

- name_prefix: Prefix used in resource names
- subnet_ids: Subnets in which the cache cluster will be placed
- security_group_ids: Security groups that can access the cluster
- node_type: ElastiCache node type
- engine_version: Redis engine version
- num_cache_nodes: Number of cache nodes
- port: Cache port
- tags: Additional resource tags

## Outputs

This module currently does not define outputs.

## Design Notes

- The cache cluster uses the private subnet group for placement.
- The implementation assumes a single-node Redis deployment by default.
- The cluster is accessible only through the provided security group IDs.

## Example Usage

```hcl
module "cache" {
  source = "../../modules/cache"

  name_prefix        = "use1"
  subnet_ids         = module.networking.private_subnet_ids
  security_group_ids = [module.networking.app_security_group_id]
  node_type          = "cache.t3.micro"
  num_cache_nodes    = 1
}
```
