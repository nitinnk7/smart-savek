#################
# Providers
#################

# provider "aws" {
#   region = "ap-southeast-2"
#   assume_role {
#     role_arn = "arn:aws:iam::626830599215:role/AWS-Cross-Account-Role-Terraform"
#   }
# }

provider "aws" {
  #profile = "MH-shared-services"
  region     = var.aws_region
}