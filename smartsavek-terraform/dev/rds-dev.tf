module "rds_private" {
  source              = "../modules/terraform-aws-rds"
  subnet_ids          = module.vpc.db_subnet_ids
  inbound_sg_ids      = ["sg-0f79fff00f8d5dfee"]
  db_name             = "appdb"
  identifier          = local.db_name
  allocated_storage   = 20
  engine              = "mysql"
  engine_version      = "13"
  instance_class      = "db.t3.medium"
  username            = "smartsevakadmin"
  skip_final_snapshot = "true"
  rds_password        = var.private_rds_password
  vpc_id              = module.vpc.vpc_id
  
}