output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnet_ids
}

output "private_subnets_ids" {
  value = module.vpc.private_subnet_ids
}

output "db_subnets_ids" {
  value = module.vpc.db_subnet_ids
}

output "availability_zones" {
  value = module.vpc.availability_zones
}

#sqs output


