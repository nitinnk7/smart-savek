variable "project" {
  type = string
}

variable "aws_region" {
  description = "AWS region to deploy the resources"
  type        = string
}

variable "vpc_region_name" {
  description = "This is used just for vpc naming convention"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "az_count" {
  description = "Count of Availability Zones"
  type        = number
  default     = 2
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = map(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = map(string)
}

variable "db_subnets" {
  description = "List of private subnet CIDRs"
  type        = map(string)
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "enable_s3_endpoint" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}



variable "web_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "web_egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "additional_tags" {
  type = map(string)
}


variable "environment" {
  type = string
}


variable "interface_endpoints" {
  description = "List of interface VPC endpoints to create"
  type        = list(string)
  default     = []
  
}





############### RDS Database ################

variable "backend_create_cluster" {
  type        = bool
  description = "Do you want to create RDS Cluster"
  default     = true
}


variable "private_rds_password" {
  description = "Master DB password of kong drupal private for prod env"
  type        = string
  default     = ""  
}

variable "backend_replica_scale_enabled" {
  description = "Whether to enable autoscaling for RDS Aurora (MySQL) read replicas"
  type        = bool
  default     = false
}

variable "backend_backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = 30
}


variable "backend_backtrack_window" {
  description = <<EOT
                 The target backtrack window, in seconds.Only available for aurora engine currently.
                 To disable backtracking, set this value to 0. Defaults to 0.
                 Must be between 0 and 259200 (72 hours)"
                EOT
  type        = number
  default     = 0
}

variable "account_management_prod_rds_password" {
  description = "Master DB password"
  type        = string
  default     = ""
}

################## EKS variables ####################

variable "eks_name" {
  type = string
  default = ""
}



######################## SQS variables #######################



variable "visibility_timeout" {
  description = "Visibility timeout in seconds"
  type        = number
  default     = 30
}

variable "message_retention" {
  description = "Message retention period in seconds"
  type        = number
  default     = 345600 # 4 days
}

variable "max_receive_count" {
  description = "How many times a message can be received before going to DLQ"
  type        = number
  default     = 5
}

variable "producer_arns" {
  description = "IAM ARNs allowed to send messages"
  type        = list(string)
  default =  []
}

variable "consumer_arns" {
  description = "IAM ARNs allowed to consume messages"
  type        = list(string)
  default = []
}



variable "create_sqs_kms" {
  description = "Whether to create a KMS key for encrypting SQS messages"
  type        = bool
  default     = true  
}

variable "create_dlq" {
  description = "Whether to create a Dead Letter Queue (DLQ) for the SQS queue"
  type        = bool
  default     = true  
}

variable "create_sqs" {
  description = "Whether to create the main SQS queue"
  type        = bool
  default     = true  
}




###################################
#documentdb variables
###################################


variable "zone_id" {
  type        = string
  default     = ""
  description = "Route53 parent zone ID. If provided (not empty), the module will create sub-domain DNS records for the DocumentDB master and replicas"
}

variable "allowed_security_groups" {
  type        = list(string)
  default     = []
  description = "List of existing Security Groups to be allowed to connect to the DocumentDB cluster"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks to be allowed to connect to the DocumentDB cluster"
}

variable "instance_class" {
  type        = string
  default     = "db.r4.large"
  description = "The instance class to use. For more details, see https://docs.aws.amazon.com/documentdb/latest/developerguide/db-instance-classes.html#db-instance-class-specs"
}

variable "cluster_size" {
  type        = number
  default     = 2
  description = "Number of DB instances to create in the cluster"
}

variable "snapshot_identifier" {
  type        = string
  default     = ""
  description = "Specifies whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a DB cluster snapshot, or the ARN when specifying a DB snapshot"
}

variable "db_port" {
  type        = number
  default     = 27017
  description = "DocumentDB port"
}

variable "master_username" {
  type        = string
  default     = "admin1"
  description = "(Required unless a snapshot_identifier is provided) Username for the master DB user"
}

variable "master_password" {
  type        = string
  default     = ""
  description = "(Required unless a snapshot_identifier is provided) Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file. Please refer to the DocumentDB Naming Constraints"
}

variable "retention_period" {
  type        = number
  default     = 5
  description = "Number of days to retain backups for"
}

variable "preferred_backup_window" {
  type        = string
  default     = "07:00-09:00"
  description = "Daily time range during which the backups happen"
}

variable "preferred_maintenance_window" {
  type        = string
  default     = "Mon:22:00-Mon:23:00"
  description = "The window to perform maintenance in. Syntax: `ddd:hh24:mi-ddd:hh24:mi`."
}

variable "cluster_parameters" {
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default     = []
  description = "List of DB parameters to apply"
}

variable "cluster_family" {
  type        = string
  default     = "docdb3.6"
  description = "The family of the DocumentDB cluster parameter group. For more details, see https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-parameter-group-create.html"
}

variable "engine" {
  type        = string
  default     = "docdb"
  description = "The name of the database engine to be used for this DB cluster. Defaults to `docdb`. Valid values: `docdb`"
}

variable "engine_version" {
  type        = string
  default     = "3.6.0"
  description = "The version number of the database engine to use"
}

variable "storage_encrypted" {
  type        = bool
  description = "Specifies whether the DB cluster is encrypted"
  default     = true
}

variable "storage_type" {
  type        = string
  description = "The storage type to associate with the DB cluster. Valid values: standard, iopt1"
  default     = "standard"

  validation {
    condition     = contains(["standard", "iopt1"], var.storage_type)
    error_message = "Error: storage_type value must be one of two options - 'standard' or 'iopt1'."
  }
}



variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted"
  default     = true
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  default     = true
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Specifies whether any minor engine upgrades will be applied automatically to the DB instance during the maintenance window or not"
  default     = true
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "List of log types to export to cloudwatch. The following log types are supported: `audit`, `profiler`"
  default     = []
}

variable "docdb_enabled" {
  type    = bool
  default = false
}

variable "docdb_name" {
  type = string
  default = ""
}

