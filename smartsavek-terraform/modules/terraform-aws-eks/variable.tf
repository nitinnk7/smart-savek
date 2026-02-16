variable "tags" {
  type = map(string)
  default = {
    "Managed By" = "Terraform"
  }
}

#### For EKS Cluster ####
variable "create_eks" {
  type        = bool
  description = "Do you want to create EKS"
  default     = true
}

variable "name" {
  type        = string
  description = "Name of the cluster"
  default     = "example-dev"
}

variable "k8s_version" {
  type        = string
  description = "Desired Kubernetes master version."
  default     = "1.17"
}

variable "enabled_cluster_log_types" {
  type        = list(any)
  description = "A list of the desired control plane logging to enable"
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cluster_log_retention_in_days" {
  type        = number
  description = "Specifies the number of days you want to retain log events in the specified log group"
  default     = 400
}

variable "key_usage" {
  type        = string
  description = "Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT or SIGN_VERIFY. Defaults to ENCRYPT_DECRYPT."
  default     = "ENCRYPT_DECRYPT"
}

variable "customer_master_key_spec" {
  type        = string
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, or ECC_SECG_P256K1. Defaults to SYMMETRIC_DEFAULT"
  default     = "SYMMETRIC_DEFAULT"
}

variable "deletion_window_in_days" {
  type        = number
  description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days."
  default     = 30
}

variable "is_enabled" {
  type        = bool
  description = "Specifies whether the key is enabled. Defaults to true."
  default     = true
}

variable "enable_key_rotation" {
  type        = bool
  description = "Specifies whether key rotation is enabled. Defaults to false"
  default     = true
}

variable "create_kms" {
  type        = bool
  description = "Specifies whether to create KMS key to encrypt cloudwatch log group"
  default     = false
}

### vpc_config Details

variable "kubernetes_network_config" {
  type        = map(string)
  description = "(Optional) Configuration block with kubernetes network configuration for the cluster. Detailed below. If removed, Terraform will only perform drift detection if a configuration value is provided."
  default     = {}
}

variable "endpoint_private_access" {
  type        = bool
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default is false."
  default     = true
}

variable "endpoint_public_access" {
  type        = bool
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default is true."
  default     = false
}

variable "public_access_cidrs" {
  type        = list(any)
  description = "List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled"
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "The VPC associated with your cluster."
}

variable "cluster_security_group_ids" {
  type        = list(any)
  description = "List of security group IDs for the cross-account elastic network interfaces that Amazon EKS creates to use to allow communication between your worker nodes and the Kubernetes control plane."
  default     = []
}

variable "worker_security_group_ids" {
  type        = list(any)
  description = "Security Group ID for Allowing pods to communicate with the EKS cluster API. only needed if you are not passing 'security_group_ids'"
  default     = []
}

variable "subnet_ids" {
  type        = list(any)
  description = "List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane."
}

variable "allowed_cidrs" {
  type        = list(any)
  description = "CIDR ranges that you want to allow commumication to EKS API"
  default     = []
}

variable "create_elb_service_linked_role" {
  type        = bool
  description = "Whether to create the service linked role for the elasticloadbalancing service. Without this EKS cannot create ELBs."
  default     = true
}

variable "aws_service_name" {
  type        = string
  description = "description"
  default     = "elasticloadbalancing.amazonaws.com"
}

variable "cluster_encryption_config" {
  description = "Configuration block with encryption configuration for the cluster. See examples/secrets_encryption/main.tf for example format"
  type = list(object({
    provider_key_arn = string
    resources        = list(string)
  }))
  default = []
}

variable "additional_assume_role_principals" {
  type    = list(string)
  default = []
}

