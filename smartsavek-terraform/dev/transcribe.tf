module "transcribe" {
  source = "../modules/terraform-aws-transcribe"

  name = "smartsevak-prod"

  create_kms_key = true
  kms_admin_arn  = ""
  
  input_bucket_arn = "arn:aws:s3:::smartsevak-dev-call-analytics-input"
  create_output_bucket = true
  output_bucket_name   = "smartsevak-dev-transcripts"

  create_vocabulary = true
  vocabulary_name   = "medical-prod"
  vocabulary_file_uri = "s3://config-bucket/medical_vocab.txt"

  create_vocabulary_filter = true
  vocabulary_filter_name   = "filter-prod"
  vocabulary_filter_file_uri = "s3://config-bucket/filter.txt"

  enable_call_analytics = true
  enable_content_redaction = true

  tags = var.tags
}
