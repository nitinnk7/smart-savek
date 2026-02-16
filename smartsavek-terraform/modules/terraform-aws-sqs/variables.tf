

############################
# DLQ SQS CONFIGURATIONS
###########################
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "environment" {
  description = "Environment name (prod, staging, dev)"
  type        = string
}

variable "queue_name" {
  description = "Main SQS queue name"
  type        = string
}

variable "visibility_timeout" {
  description = "Visibility timeout in seconds"
  type        = number
}

variable "message_retention" {
  description = "Message retention period in seconds"
  type        = number
}

variable "max_receive_count" {
  description = "How many times a message can be received before going to DLQ"
  type        = number
}

variable "producer_arns" {
  description = "IAM ARNs allowed to send messages"
  type        = list(string)
}

variable "consumer_arns" {
  description = "IAM ARNs allowed to consume messages"
  type        = list(string)
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}

variable "create_sqs_kms" {
  description = "Whether to create a KMS key for encrypting SQS messages"
  type        = bool  
}

variable "create_dlq" {
  description = "Whether to create a Dead Letter Queue (DLQ) for the SQS queue"
  type        = bool 
}

variable "create_sqs" {
  description = "Whether to create the main SQS queue"
  type        = bool 
}