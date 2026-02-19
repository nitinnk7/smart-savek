output "kms_key_arn" {
  value = var.create_kms_key ? aws_kms_key.this[0].arn : var.external_kms_arn
}

output "output_bucket_arn" {
  description = "ARN of the transcript output bucket"

  value = var.create_output_bucket ? aws_s3_bucket.output[0].arn : var.output_bucket_arn
}

