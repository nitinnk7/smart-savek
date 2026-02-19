data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  effective_kms_key = var.create_kms_key ? try(aws_kms_key.this[0].arn, null) : var.kms_key_arn

  effective_sg_ids = var.create_security_group ? concat([aws_security_group.this[0].id], var.security_group_ids) : var.security_group_ids
}
