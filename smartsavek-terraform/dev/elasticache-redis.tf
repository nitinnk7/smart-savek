module "redis" {
  source = "../modules/terraform-aws-elasticache-redis"

  name        = "orders"
  environment = "dev"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.db_subnet_ids

  allowed_security_group_ids = ["sg-0f79fff00f8d5dfee"]

  slow_log_destination   = ""
  engine_log_destination = ""

  tags = var.tags
}
