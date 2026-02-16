locals {
  enabled         = var.enabled
  create_password = local.enabled && var.master_password == null && var.manage_master_user_password == null
  # 1. If manage_master_user_password is not null, AWS manages the password (master_password must be null)
  # 2. If master_password is provided, that value is used (manage_master_user_password must be null)
  # 3. If both are null, the module creates a random password
  master_password = local.create_password ? one(random_password.password[*].result) : var.master_password
  name    = var.docdb_name
  tags    = var.tags
  docdb_sg_ids = local.enabled ? aws_security_group.docdb_sg[*].id : []
}

resource "aws_db_subnet_group" "docdb_subnet_group" {
  name       = "${var.docdb_name}_subnet_group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "docdb_sg" {
  name        = "${var.docdb_name}-docdb-security-group"
  description = "Security group associated with the DOCUMENTDB cluster"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 27017
    to_port         = 27017
    security_groups = var.inbound_sg_ids
    
  }
}


resource "random_password" "password" {
  count   = local.create_password ? 1 : 0
  length  = 16
  special = false
}

resource "aws_docdb_cluster" "default" {
  count              = local.enabled ? 1 : 0
  cluster_identifier = local.name
  master_username    = var.master_username
  # Set master_password OR manage_master_user_password, but not both (one must be null)
  # manage_master_user_password=true enables AWS-managed passwords via Secrets Manager
  master_password                 = var.manage_master_user_password != null ? null : local.master_password
  manage_master_user_password     = var.manage_master_user_password
  backup_retention_period         = var.retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  final_snapshot_identifier       = lower(local.name)
  skip_final_snapshot             = var.skip_final_snapshot
  deletion_protection             = var.deletion_protection
  apply_immediately               = var.apply_immediately
  storage_encrypted               = var.storage_encrypted
  storage_type                    = var.storage_type
  kms_key_id                      = aws_kms_key.docdb.key_id
  port                            = var.db_port
  snapshot_identifier             = var.snapshot_identifier
  vpc_security_group_ids          = concat(aws_security_group.docdb_sg[*].id, var.external_security_group_id_list)
  db_subnet_group_name            = aws_db_subnet_group.docdb_subnet_group.name
  db_cluster_parameter_group_name = join("", aws_docdb_cluster_parameter_group.default[*].name)
  engine                          = var.engine
  engine_version                  = var.engine_version
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  allow_major_version_upgrade     = var.allow_major_version_upgrade
  tags                            = local.tags


  lifecycle {
    precondition {
      condition     = (var.serverless_v2_scaling_configuration != null && contains(["db.serverless"], var.instance_class)) || (var.serverless_v2_scaling_configuration == null && var.instance_class != "db.serverless")
      error_message = "Error: when serverless_v2_scaling_configuration is set, instance_class must be set to 'db.serverless'"
    }
  }
}

resource "aws_docdb_cluster_instance" "default" {
  count                        = local.enabled ? var.cluster_size : 0
  identifier                   = "${local.name}-${count.index + 1}"
  cluster_identifier           = join("", aws_docdb_cluster.default[*].id)
  apply_immediately            = var.apply_immediately
  preferred_maintenance_window = var.preferred_maintenance_window
  instance_class               = var.instance_class
  engine                       = var.engine
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  enable_performance_insights  = var.enable_performance_insights
  ca_cert_identifier           = var.ca_cert_identifier
  tags                         = local.tags
}


# https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-parameter-group-create.html
resource "aws_docdb_cluster_parameter_group" "default" {
  count       = local.enabled ? 1 : 0
  name        = local.name
  description = "DB cluster parameter group"
  family      = var.cluster_family

  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  tags =local.tags
}

