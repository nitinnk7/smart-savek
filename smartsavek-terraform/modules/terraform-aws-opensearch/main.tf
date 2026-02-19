resource "aws_opensearch_domain" "this" {
  count         = var.enabled ? 1 : 0
  domain_name   = var.name
  engine_version = var.engine_version

  cluster_config {
    instance_type  = var.instance_type
    instance_count = var.instance_count

    zone_awareness_enabled = var.zone_awareness_enabled

    dynamic "zone_awareness_config" {
      for_each = var.zone_awareness_enabled ? [1] : []
      content {
        availability_zone_count = var.availability_zone_count
      }
    }

    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_type    = var.dedicated_master_type
    dedicated_master_count   = var.dedicated_master_count

    warm_enabled = var.warm_enabled
    warm_type    = var.warm_type
    warm_count   = var.warm_count
  }

  dynamic "ebs_options" {
    for_each = var.ebs_enabled ? [1] : []
    content {
      ebs_enabled = true
      volume_size = var.volume_size
      volume_type = var.volume_type
      iops        = var.iops
      throughput  = var.throughput
    }
  }

  encrypt_at_rest {
    enabled    = var.encrypt_at_rest_enabled
    kms_key_id = var.encrypt_at_rest_enabled ? local.effective_kms_key : null
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption_enabled
  }

  domain_endpoint_options {
    enforce_https = var.enforce_https
  }

  dynamic "advanced_security_options" {
    for_each = var.advanced_security_enabled ? [1] : []
    content {
      enabled                        = true
      internal_user_database_enabled = var.internal_user_database_enabled

      dynamic "master_user_options" {
        for_each = var.master_user_arn != null || var.master_user_name != null ? [1] : []
        content {
          master_user_arn      = var.master_user_arn
          master_user_name     = var.master_user_name
          master_user_password = var.master_user_password
        }
      }
    }
  }

  dynamic "log_publishing_options" {
    for_each = var.log_publishing_options
    content {
      log_type                 = log_publishing_options.value.log_type
      cloudwatch_log_group_arn = log_publishing_options.value.cloudwatch_log_group_arn
    }
  }

  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }

  auto_tune_options {
    desired_state = var.auto_tune_enabled ? "ENABLED" : "DISABLED"
  }

  dynamic "domain_endpoint_options" {
    for_each = var.custom_endpoint_enabled ? [1] : []
    content {
      custom_endpoint_enabled         = true
      custom_endpoint                 = var.custom_endpoint
      custom_endpoint_certificate_arn = var.custom_endpoint_certificate_arn
      enforce_https                   = var.enforce_https
    }
  }

  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.allowed_iam_role_arns
        }
        Action   = "es:*"
        Resource = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.name}/*"
      }
    ]
  })

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = local.effective_sg_ids
  }

  tags = var.tags
}
