output "cache_primary_endpoint" {
  description = "Primary endpoint address for the cache cluster"
  value       = aws_elasticache_cluster.this.cache_nodes[0].address
}

output "cache_primary_port" {
  description = "Primary endpoint port for the cache cluster"
  value       = aws_elasticache_cluster.this.cache_nodes[0].port
}

output "subnet_group" {
  description = "ElastiCache subnet group name"
  value       = aws_elasticache_subnet_group.this.name
}
