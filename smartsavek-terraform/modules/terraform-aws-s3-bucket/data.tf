data "aws_caller_identity" "current" {}

data "aws_canonical_user_id" "this" {}

locals {
  create_bucket = var.create_bucket

  # Variables with type `any` should be jsonencode()'d when value is coming from Terragrunt
  grants          = try(jsondecode(var.grant), var.grant)
  cors_rules      = try(jsondecode(var.cors_rule), var.cors_rule)
  lifecycle_rules = try(jsondecode(var.lifecycle_rule), var.lifecycle_rule)
}