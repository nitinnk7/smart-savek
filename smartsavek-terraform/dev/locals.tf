locals {

  name                           = format("%s-%s", lower(var.project), var.environment)
  eks_name = format("%s-%s", local.name, "cluster")
  db_name = format("%s-%s", local.name, "rds")
  # Common tags for all resources
  common_tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
  additional_tags = var.additional_tags


  # Availability zones
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}