output "rds_sg" {
  description = "Security group generated for the RDS"
  value       = aws_security_group.rds_sg
}

output "rds_instance" {
  description = "Instance of the RDS"
  value       = aws_db_instance.rds
}
