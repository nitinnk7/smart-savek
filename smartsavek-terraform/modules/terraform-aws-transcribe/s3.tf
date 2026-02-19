
resource "aws_s3_bucket" "output" {
  count = var.create_output_bucket ? 1 : 0

  bucket        = var.output_bucket_name
  force_destroy = var.force_destroy_bucket
  tags          = var.tags
}

resource "aws_s3_bucket_versioning" "output" {
  count = var.create_output_bucket && var.enable_bucket_versioning ? 1 : 0

  bucket = aws_s3_bucket.output[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "output" {
  count = var.create_output_bucket ? 1 : 0

  bucket = aws_s3_bucket.output[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.create_kms_key ? "aws:kms" : "AES256"
      kms_master_key_id = var.create_kms_key ? aws_kms_key.this[0].arn : null
    }
  }
}

resource "aws_s3_bucket_public_access_block" "output" {
  count = var.create_output_bucket ? 1 : 0

  bucket = aws_s3_bucket.output[0].id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "output" {
  count = var.create_output_bucket && var.enable_bucket_lifecycle ? 1 : 0

  bucket = aws_s3_bucket.output[0].id

  rule {
    id     = "transcript-lifecycle"
    status = "Enabled"

    filter {}   

   transition {
    days          = 30
    storage_class = "STANDARD_IA"
}

   transition {
    days          = 90
    storage_class = "GLACIER"
}


    expiration {
      days = var.lifecycle_expiration_days
    }
  }
}


resource "aws_s3_bucket_policy" "transcribe_bucket_policy" {
  count = var.create_output_bucket ? 1 : 0

  bucket = aws_s3_bucket.output[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "transcribe.amazonaws.com"
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = "${aws_s3_bucket.output[0].arn}/*"
      }
    ]
  })
}