variable "enable_peering" {
  default = false
}

variable "peer_vpc_id" {
  description = "VPC ID of the peer VPC"
  type        = string
}

variable "peer_account_id" {
  description = "Account ID of the peer"
  type        = string
}

variable "peer_region" {
  default = "ap-southeast-2"
}

variable "peer_cidr_block" {
  description = "CIDR block of peer VPC"
  type        = string
}

variable "vpc_name" {
     type = string 
     }

variable "tags" {
     type = map(string) 
     }

variable "vpc_id" {
  type = string
}

variable "private_route_table_ids" {
  type = list(string)
}