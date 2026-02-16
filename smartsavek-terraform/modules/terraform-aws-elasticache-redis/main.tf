resource "random_password" "auth_token" {
  length  = 32
  special = false
}

resource "aws_security_group" "redis" {
  name        = "${var.environment}-${var.name}-redis"
  description = "Redis security group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.name}-redis"
  })
}

resource "aws_security_group_rule" "sg_ingress" {
  for_each = toset(var.allowed_security_group_ids)

  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.redis.id
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "cidr_ingress" {
  for_each = toset(var.allowed_cidr_blocks)

  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  security_group_id = aws_security_group.redis.id
  cidr_blocks       = [each.value]
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.environment}-${var.name}"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

locals {
  slow_log   = var.slow_log_destination == null ? [] : [1]
  engine_log = var.engine_log_destination == null ? [] : [1]
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = "${var.environment}-${var.name}"
  description                = "Production Redis for ${var.name}"

  engine                     = "redis"
  engine_version             = var.engine_version
  node_type                  = var.node_type
  port                       = var.port

  num_cache_clusters         = var.num_cache_clusters
  automatic_failover_enabled = var.automatic_failover_enabled
  multi_az_enabled           = var.multi_az_enabled

  subnet_group_name          = aws_elasticache_subnet_group.redis.name
  security_group_ids         = [aws_security_group.redis.id]

  transit_encryption_enabled = true
  auth_token                 = random_password.auth_token.result

  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  kms_key_id                 = var.at_rest_encryption_enabled ? var.kms_key_arn : null

  snapshot_window            = var.snapshot_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  maintenance_window         = var.maintenance_window

  dynamic "log_delivery_configuration" {
    for_each = local.slow_log
    content {
      destination      = var.slow_log_destination
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "slow-log"
    }
  }

  dynamic "log_delivery_configuration" {
    for_each = local.engine_log
    content {
      destination      = var.engine_log_destination
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "engine-log"
    }
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.name}"
  })
}
