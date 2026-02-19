data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_kms_key" "this" {
  count               = var.create_kms_key ? 1 : 0
  description         = "${var.name} KMS key for Transcribe"
  enable_key_rotation = var.enable_key_rotation

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # Admin access
      {
        Sid    = "AllowAdminAccess"
        Effect = "Allow"
        Principal = {
          AWS = var.kms_admin_arn != null ? var.kms_admin_arn : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },

      # Allow Transcribe service to use the key
      {
        Sid    = "AllowTranscribeService"
        Effect = "Allow"
        Principal = {
          Service = "transcribe.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }

    ]
  })

  tags = var.tags
}
