output "vpc_id1" {
  value = module.networking_use1.vpc_id
}

output "public_subnet_ids1" {
  value = module.networking_use1.public_subnet_ids
}

output "private_subnet_ids1" {
  value = module.networking_use1.private_subnet_ids
}


# The compute outputs are mentioned below
output "use1_alb_dns_name" {
  description = "The URL to access your application in US-East-1"
  value       = module.compute_use1.alb_dns_name
}

output "use1_asg_name" {
  description = "The Auto Scaling Group name for US-East-1"
  value       = module.compute_use1.asg_name
}

#Db outputs are listed below

output "database_endpoint" {
  value = module.database_use1.db_endpoint
}

output "database_port" {
  value = module.database_use1.db_port
}