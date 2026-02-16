resource "aws_kms_key" "this" {
  count                    = var.create_eks && var.create_kms ? 1 : 0
  description              = format("KMS key for %s EKS cluster", var.name)
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  policy                   = data.aws_iam_policy_document.kms[0].json
  deletion_window_in_days  = var.deletion_window_in_days
  is_enabled               = var.is_enabled
  enable_key_rotation      = var.enable_key_rotation
  tags                     = var.tags
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_kms_alias" "this" {
  count         = var.create_eks && var.create_kms ? 1 : 0
  name          = format("alias/eks-%s", var.name)
  target_key_id = join("", aws_kms_key.this.*.key_id)
  lifecycle {
    create_before_destroy = true
  }
}
