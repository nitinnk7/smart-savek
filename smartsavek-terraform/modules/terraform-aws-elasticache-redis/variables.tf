variable "name" {
  description = "Base name for Redis"
  type        = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "Private subnets for Redis"
  type        = list(string)
}

variable "node_type" {
  type        = string
  default     = "cache.t4g.small"
}

variable "engine_version" {
  type        = string
  default     = "7.1"
}

variable "port" {
  type    = number
  default = 6379
}

variable "num_cache_clusters" {
  description = "Number of Redis nodes (1 primary + replicas)"
  type        = number
  default     = 2
}

variable "multi_az_enabled" {
  type    = bool
  default = true
}

variable "automatic_failover_enabled" {
  type    = bool
  default = true
}

variable "at_rest_encryption_enabled" {
  type    = bool
  default = true
}

variable "kms_key_arn" {
  type    = string
  default = null
}

variable "maintenance_window" {
  type    = string
  default = "sun:05:00-sun:06:00"
}

variable "snapshot_window" {
  type    = string
  default = "04:00-05:00"
}

variable "snapshot_retention_limit" {
  type    = number
  default = 7
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to access Redis"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  type    = list(string)
  default = []
}

variable "slow_log_destination" {
  type    = string
  default = null
}

variable "engine_log_destination" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
