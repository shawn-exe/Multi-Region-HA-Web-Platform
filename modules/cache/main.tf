resource "aws_elasticache_subnet_group" "this" {
	name       = "${var.name_prefix}-subnet-group"
	subnet_ids = var.subnet_ids
	description = "Subnet group for ${var.name_prefix} ElastiCache"
}

resource "aws_elasticache_cluster" "this" {
  cluster_id        = "${var.name_prefix}-cache"
  engine            = "redis"
  engine_version    = var.engine_version
  node_type         = var.node_type
  num_cache_nodes   = var.num_cache_nodes
  subnet_group_name = aws_elasticache_subnet_group.this.name
  port              = var.port

  security_group_ids = var.security_group_ids

  tags = merge(
    {
      Name = "${var.name_prefix}-cache"
    },
    var.tags
  )
}
