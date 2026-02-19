variable "enabled" { 
  type = bool 
 default = true 
}
variable "name" { type = string }
variable "tags" { 
  type = map(string) 
  default = {} 
  }

# ---------------- VPC ----------------

variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }

variable "create_security_group" { 
  type = bool 
  default = true 
}
variable "security_group_ids" { 
  type = list(string) 
  default = [] 
  }
variable "allowed_security_group_ids" { 
  type = list(string) 
  default = [] 
  }
variable "allowed_cidr_blocks" { 
  type = list(string) 
  default = [] 
  }

# ---------------- Engine ----------------

variable "engine_version" {
  type    = string
  default = "OpenSearch_2.11"
}

# ---------------- Cluster ----------------

variable "instance_type" { type = string }
variable "instance_count" { type = number }

variable "zone_awareness_enabled" { 
  type = bool 
  default = false 
  }
variable "availability_zone_count" { 
  type = number 
  default = 2 
  }

variable "dedicated_master_enabled" { 
  type = bool 
  default = false 
}
variable "dedicated_master_type" { 
  type = string 
  default = null 
  }
variable "dedicated_master_count" { 
  type = number 
  default = 0 
  }

variable "warm_enabled" { 
  type = bool 
  default = false 
}
variable "warm_type" { 
  type = string 
  default = null 
  }

variable "warm_count" { 
  type = number 
  default = 2 
  }

# ---------------- Storage ----------------

variable "ebs_enabled" { 
  type = bool 
  default = true 
}
variable "volume_size" { 
  type = number 
  default = 20 
  }
variable "volume_type" { 
  type = string 
  default = "gp3" 
  }
variable "iops" { 
  type = number 
  default = null 
  }
variable "throughput" { 
  type = number 
  default = null 
  }

# ---------------- Encryption ----------------

variable "encrypt_at_rest_enabled" { 
  type = bool 
  default = true 
  }
variable "create_kms_key" { 
  type = bool 
  default = true 
  }
variable "kms_key_arn" { 
  type = string 
  default = null 
  }
variable "node_to_node_encryption_enabled" { 
  type = bool 
  default = true 
  }
variable "enforce_https" { 
  type = bool 
  default = true 
  }

# ---------------- Advanced Security ----------------

variable "advanced_security_enabled" { 
  type = bool 
  default = true 
  }
variable "internal_user_database_enabled" { 
  type = bool 
  default = false 
  }
variable "master_user_arn" { 
  type = string 
  default = null 
  }
variable "master_user_name" { 
  type = string 
  default = null 
  }
variable "master_user_password" { 
  type = string 
  default = null 
  sensitive = true
  }

variable "allowed_iam_role_arns" {
  type    = list(string)
  default = []
}

# ---------------- Logging ----------------

variable "log_publishing_options" {
  type = map(object({
    log_type                 = string
    cloudwatch_log_group_arn = string
  }))
  default = {}
}

# ---------------- Snapshot ----------------

variable "automated_snapshot_start_hour" {
  type    = number
  default = 3
}

# ---------------- Auto Tune ----------------

variable "auto_tune_enabled" {
  type    = bool
  default = false
}

# ---------------- Custom Endpoint ----------------

variable "custom_endpoint_enabled" { 
  type = bool 
  default = false 
}
variable "custom_endpoint" { 
  type = string 
  default = null 
  }
variable "custom_endpoint_certificate_arn" { 
  type = string 
  default = null 
  }
