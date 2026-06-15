output "db_endpoint" {
  value = aws_db_instance.primary.address
}

output "db_port" {
  value = aws_db_instance.primary.port
}

output "replica_endpoints" {
  value = aws_db_instance.read_replica[*].address
}