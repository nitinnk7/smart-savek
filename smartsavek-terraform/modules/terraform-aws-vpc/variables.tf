variable "vpc_name" { 
  type = string 
  }
variable "aws_region" { 
  description = "AWS region to deploy VPC"
  type = string 
  }
variable "cidr_block" { 
  type = string 
  }

# How many AZs to use (we will slice the available AZs to this count).
variable "az_count" { 
  type = number
  default = 2 
  }


variable "public_subnets"  { 
  type = map(string) 
  }
variable "private_subnets" { 
  type = map(string) 
  }
variable "db_subnets"      { 
  type = map(string) 
  }

variable "enable_nat_gateway" { 
  type = bool 
  default = true 
  }

variable "tags" {
  description = "Common tags to apply"
  type        = map(string)
  default     = {}
}

variable "enable_s3_endpoint" {
     type = bool 
     }


# variable "enable_peering" {
#   default = false
# }

# variable "peer_vpc_id" {
#   description = "VPC ID of the peer VPC"
#   type        = string
# }

# variable "peer_account_id" {
#   description = "Account ID of the peer"
#   type        = string
# }

# variable "peer_region" {
#   default = "ap-southeast-2"
# }

# variable "peer_cidr_block" {
#   description = "CIDR block of peer VPC"
#   type        = string
# }

# vpc interface endpoints variiable 
variable "interface_endpoints" {
  description = "List of interface VPC endpoints to create"
  type        = list(string)
  default     = []
  
}

# variables of vpc security group

variable "description" {
  type    = string
  default = "Managed by Terraform"
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

