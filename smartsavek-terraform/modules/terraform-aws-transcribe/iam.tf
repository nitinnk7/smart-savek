resource "aws_iam_role" "transcribe_service" {
  name = "${var.name}-transcribe-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "transcribe.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_policy" "transcribe_service" {
  name = "${var.name}-transcribe-service-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Resource = "${var.create_output_bucket ? aws_s3_bucket.output[0].arn : var.output_bucket_arn}/*"

      },
      {
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = var.create_kms_key ? aws_kms_key.this[0].arn : var.external_kms_arn

      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "transcribe_service" {
  role       = aws_iam_role.transcribe_service.name
  policy_arn = aws_iam_policy.transcribe_service.arn
}
