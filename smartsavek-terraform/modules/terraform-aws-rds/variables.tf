/* Must exist in the same VPC as the RDS security group */
variable "subnet_ids" {
  description = "List of subnets for the required subnet group for the rds object"
  type        = list(string)
}

/* Must exist in the same VPC as the Subnet list provided above */
variable "inbound_sg_ids" {
  description = "ID of the security group you want to be able to reach the RDS"
  type        = list(string)
}

variable "rds_password" {
  description = "Password for the RDS. Passed seperatly from the rest of the object - allows for passing as CLI argument when running Terraform."
  type        = string
  sensitive   = true
}

/* VPC id to deploy the RDS into */
variable "vpc_id" {
  description = "VPC_ID of the VPC the RDS instance is being deployed onto"
  type        = string
}

variable "db_name" {
  description = "Name of rds db"
  type        = string
}

variable "identifier" {
  description = "identifier of rds"
  type        = string
}
variable "allocated_storage" {
  description = "Allocated storage of rds"
  type        = string
}
variable "engine" {
  description = "Engine used in rds"
  type        = string
}
variable "engine_version" {
  description = " "
  type        = string
}

variable "instance_class" {
  description = "Instance class of rds"
  type        = string
}
variable "username" {
  description = "Username of rds"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot of rds"
  type        = string
}

