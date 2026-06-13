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