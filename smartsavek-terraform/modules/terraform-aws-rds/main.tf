resource "aws_db_subnet_group" "default" {
  name       = "${var.db_name}_subnet_group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.identifier}-rds-security-group"
  description = "Security group associated with the RDS"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    security_groups = var.inbound_sg_ids
    
  }
}

resource "aws_db_instance" "rds" {
  db_name                     = var.db_name
  identifier                  = (var.identifier)
  allocated_storage           = var.allocated_storage
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  username                    = var.username
  password                    = var.rds_password
  skip_final_snapshot         = var.skip_final_snapshot
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]
  db_subnet_group_name        = aws_db_subnet_group.default.name
  allow_major_version_upgrade = false
}

