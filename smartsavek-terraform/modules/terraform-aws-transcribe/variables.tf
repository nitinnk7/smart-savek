variable "name" {
  type        = string
  description = "Base name for all resources"
}

variable "tags" {
  type        = map(string)
  default     = {}
}

# -----------------------------
# S3 Configuration
# -----------------------------

variable "create_output_bucket" {
  type    = bool
  default = true
}

variable "output_bucket_name" {
  type    = string
  default = null
}

variable "output_bucket_arn" {
  type        = string
  default     = null
  description = "External bucket ARN (used if create_output_bucket = false)"
}

variable "enable_bucket_versioning" {
  type    = bool
  default = true
}

variable "enable_bucket_lifecycle" {
  type    = bool
  default = true
}

variable "lifecycle_transition_days" {
  type    = number
  default = 30
}

variable "lifecycle_expiration_days" {
  type    = number
  default = 365
}

variable "force_destroy_bucket" {
  type    = bool
  default = false
}

# -----------------------------
# KMS Configuration
# -----------------------------

variable "create_kms_key" {
  type    = bool
  default = true
}

variable "kms_admin_arn" {
  type        = string
  default     = null
  description = "Admin ARN for KMS"
}

variable "enable_key_rotation" {
  type    = bool
  default = true
}

# -----------------------------
# Vocabulary
# -----------------------------

variable "create_vocabulary" {
  type    = bool
  default = false
}

variable "vocabulary_name" {
  type    = string
  default = null
}

variable "vocabulary_file_uri" {
  type    = string
  default = null
}

variable "language_code" {
  type    = string
  default = "en-IN"
}

# -----------------------------
# Vocabulary Filter
# -----------------------------

variable "create_vocabulary_filter" {
  type    = bool
  default = false
}

variable "vocabulary_filter_name" {
  type    = string
  default = null
}

variable "vocabulary_filter_file_uri" {
  type    = string
  default = null
}

# -----------------------------
# Call Analytics / Redaction
# -----------------------------

variable "enable_call_analytics" {
  type    = bool
  default = false
}

variable "enable_content_redaction" {
  type    = bool
  default = true
}

variable "pii_entity_types" {
  type    = string
  default = "ALL"
}

variable "external_kms_arn" {
  type        = string
  default     = ""
  description = "External KMS ARN (used if create_kms_key = false)"
  }

  variable "input_bucket_arn" {
  type        = string
  default     = ""
  description = "ARN of the input bucket for call analytics"
  }