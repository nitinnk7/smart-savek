data "aws_caller_identity" "current" {}

resource "aws_kms_key" "docdb" {
  description             = "KMS key for Amazon DocumentDB encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableRootPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowDocumentDBUse"
        Effect = "Allow"
        Principal = {
          Service = "docdb.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "docdb" {
  name          = "alias/documentdb"
  target_key_id = aws_kms_key.docdb.key_id
}
