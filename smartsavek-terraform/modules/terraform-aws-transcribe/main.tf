resource "aws_transcribe_vocabulary" "this" {
  count = var.create_vocabulary ? 1 : 0

  vocabulary_name     = var.vocabulary_name
  language_code       = var.language_code
  vocabulary_file_uri = var.vocabulary_file_uri

  tags = var.tags
}

resource "aws_transcribe_vocabulary_filter" "this" {
  count = var.create_vocabulary_filter ? 1 : 0

  vocabulary_filter_name     = var.vocabulary_filter_name
  language_code              = var.language_code
  vocabulary_filter_file_uri = var.vocabulary_filter_file_uri
}
