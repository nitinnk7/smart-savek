# terraform {
#   backend "s3" {
#     bucket = "stuffnz-terraform-state-store"
#     key    = "stuff-ss/terraform-ss.tfstate"
#     region = "ap-southeast-2"
#   }
#   #required_version = ">= 0.14, < 1.1"
#   required_version = "1.2.3"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "4.60"
#     }
#     null = {
#       source  = "hashicorp/null"
#       version = "3.2.1"
#     }
#   }
#}
