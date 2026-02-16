


module "vpc" {
  source             = "../modules/terraform-aws-vpc"
  vpc_name           = "${var.project}-${var.environment}-${var.vpc_region_name}"
  aws_region         = var.aws_region
  cidr_block         = var.cidr_block
  az_count           = var.az_count
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  db_subnets         = var.db_subnets 
  enable_nat_gateway = var.enable_nat_gateway
  enable_s3_endpoint = var.enable_s3_endpoint
  interface_endpoints = var.interface_endpoints
  tags               = var.tags
}



#module "web_sg" {
#  source      = "../modules/terraform-aws-security-group"
#   name_prefix = "${var.vpc_name}-web"
#   vpc_id      = module.vpc.vpc_id
#   tags        = var.tags

#   ingress_rules = var.web_ingress_rules
#   egress_rules  = var.web_egress_rules
# }

