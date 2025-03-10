resource "aws_db_instance" "this" {
  identifier              = var.db_instance_identifier
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [var.security_group_id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  backup_retention_period = var.backup_retention_period
  multi_az                = var.multi_az
}

resource "aws_db_subnet_group" "this" {
  name        = "${var.db_instance_identifier}-subnet-group"
  subnet_ids  = var.subnets

  tags        = {
    Name      = "${var.db_instance_identifier}-subnet-group"
  }
}
