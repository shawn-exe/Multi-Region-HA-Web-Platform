# Here the replicas are in same region. For Cross regiion repicas use the private subnet from usw2
# Make changes in the versions.tf file to tell that the module can use multiple regions.

resource "aws_db_instance" "read_replica" {
  count = var.replica_count

  identifier = "${var.name_prefix}-db-replica-${count.index + 1}"

  replicate_source_db = aws_db_instance.primary.identifier

  instance_class = var.replica_instance_class

  publicly_accessible = false

  storage_encrypted = true

  skip_final_snapshot = true

  tags = {
    Name = "${var.name_prefix}-db-replica-${count.index + 1}"
  }
}