terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

############################
# LOCALS 
############################

locals {
  kms_key_id = try(aws_kms_key.sqs["key"].id, null)
  dlq_arn    = try(aws_sqs_queue.dlq["dlq"].arn, null)
  main_arn   = try(aws_sqs_queue.main["main"].arn, null)
}

############################
# KMS KEY FOR SQS
############################

resource "aws_kms_key" "sqs" {
  for_each = var.create_sqs_kms ? { key = "enabled" } : {}

  description             = "KMS key for encrypting SQS messages"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = data.aws_iam_policy_document.kms.json

  tags = merge(var.tags, {
    Name = "${var.queue_name}-kms-key-sqs"
  })
}

resource "aws_kms_alias" "sqs" {
  for_each = var.create_sqs_kms ? { key = "enabled" } : {}

  name          = "alias/sqs-${var.environment}"
  target_key_id = local.kms_key_id
}

data "aws_iam_policy_document" "kms" {
  statement {
    sid    = "EnableRootPermissions"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowSQSUseOfKey"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sqs.amazonaws.com"]
    }

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = ["*"]
  }
}

############################
# DEAD LETTER QUEUE
############################

resource "aws_sqs_queue" "dlq" {
  for_each = var.create_dlq ? { dlq = "enabled" } : {}

  name                      = "${var.queue_name}-dlq"
  message_retention_seconds = 1209600 # 14 days

  kms_master_key_id = local.kms_key_id

  tags = merge(var.tags, {
    Name = "${var.queue_name}-dlq"
  })
}

############################
# MAIN QUEUE
############################

resource "aws_sqs_queue" "main" {
  for_each = var.create_sqs ? { main = "enabled" } : {}

  name                       = var.queue_name
  visibility_timeout_seconds = var.visibility_timeout
  message_retention_seconds  = var.message_retention
  receive_wait_time_seconds  = 20
  max_message_size           = 262144

  kms_master_key_id = local.kms_key_id

  redrive_policy = local.dlq_arn != null ? jsonencode({
    deadLetterTargetArn = local.dlq_arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = merge(var.tags, {
    Name = "${var.queue_name}-sqs"
  })
}

############################
# QUEUE POLICY
############################

data "aws_iam_policy_document" "sqs_policy" {
  count = var.create_sqs ? 1 : 0

  statement {
    sid    = "AllowProducers"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.producer_arns
    }

    actions   = ["sqs:SendMessage"]
    resources = [local.main_arn]
  }

  statement {
    sid    = "AllowConsumers"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.consumer_arns
    }

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]

    resources = [local.main_arn]
  }
}

resource "aws_sqs_queue_policy" "main" {
  count = var.create_sqs ? 1 : 0

  queue_url = local.main_arn
  policy    = data.aws_iam_policy_document.sqs_policy[0].json
}
