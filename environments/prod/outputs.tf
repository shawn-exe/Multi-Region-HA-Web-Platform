
# outputs for networking:

output "vpc_id1" {
  value = module.networking_use1.vpc_id
}

output "vpc_id2" {
  value = module.networking_usw2.vpc_id
}

output "public_subnet_ids1" {
  value = module.networking_use1.public_subnet_ids
}

output "public_subnet_ids2" {
  value = module.networking_usw2.public_subnet_ids
}

output "private_subnet_ids1" {
  value = module.networking_use1.private_subnet_ids
}

output "private_subnet_ids2" {
  value = module.networking_usw2.private_subnet_ids
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

output "usw2_alb_dns_name" {
  description = "The URL to access your application in US-West-2"
  value       = module.compute_usw2.alb_dns_name
}

output "usw2_asg_name" {
  description = "The Auto Scaling Group name for US-West-2"
  value       = module.compute_usw2.asg_name
}