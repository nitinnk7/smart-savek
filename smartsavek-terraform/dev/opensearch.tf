module "opensearch" {
  source = "../modules/terraform-aws-opensearch"

  # -------- Required --------
  name           = "smartsevak-dev"
  engine_version = ""
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_ids
  instance_type  = "t3.small.search"
  instance_count = 2
  zone_awareness_enabled = true
  availability_zone_count = 2

  # -------- Security --------
  create_security_group = true
  allowed_security_group_ids = [""]

  advanced_security_enabled = true
  master_user_arn           = ""
  master_user_name          = ""
  master_user_password      = ""
  allowed_iam_role_arns = []

  # -------- Optional --------
  volume_size = 20
  auto_tune_enabled = false
  warm_count = 3

  tags = var.tags
}
