# Primary Aurora Cluster in us-east-1
resource "aws_rds_global_cluster" "this" {
  global_cluster_identifier = "aurora-global-db"
  engine                    = "aurora-mysql"
  engine_version            = "8.0.mysql_aurora.3.02.0"
  database_name             = "mydatabase"
}

resource "aws_rds_cluster" "primary" {
  #  provider = aws.us_east_1

  cluster_identifier        = "aurora-primary-cluster"
  engine                    = aws_rds_global_cluster.this.engine
  engine_version            = aws_rds_global_cluster.this.engine_version
  database_name             = aws_rds_global_cluster.this.database_name
  master_username           = var.db_username
  master_password           = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.primary.name
  vpc_security_group_ids    = [var.security_group_id]
  skip_final_snapshot       = true
  global_cluster_identifier = aws_rds_global_cluster.this.id
}

resource "aws_rds_cluster_instance" "primary" {
  #  provider = aws.us_east_1
  
  cluster_identifier = aws_rds_cluster.primary.id
  instance_class     = var.db_instance_class
  engine             = aws_rds_cluster.primary.engine
  engine_version     = aws_rds_cluster.primary.engine_version
}

resource "aws_db_subnet_group" "primary" {
  #  provider = aws.us_east_1
  
  name       = "aurora-primary-subnet-group"
  subnet_ids = var.primary_subnets

  tags = {
    Name = "aurora-primary-subnet-group"
  }
}

# Secondary Aurora Cluster in us-west-2
resource "aws_rds_cluster" "secondary" {
  provider = aws.us_west_2

  cluster_identifier        = "aurora-secondary-cluster"
  engine                    = aws_rds_global_cluster.this.engine
  engine_version            = aws_rds_global_cluster.this.engine_version
  database_name             = aws_rds_global_cluster.this.database_name
  db_subnet_group_name      = aws_db_subnet_group.secondary.name
  vpc_security_group_ids    = [var.security_group_id]
  skip_final_snapshot       = true
  global_cluster_identifier = aws_rds_global_cluster.this.id
}

resource "aws_rds_cluster_instance" "secondary" {
  provider = aws.us_west_2

  cluster_identifier = aws_rds_cluster.secondary.id
  instance_class     = var.db_instance_class
  engine             = aws_rds_cluster.secondary.engine
  engine_version     = aws_rds_cluster.secondary.engine_version
}

resource "aws_db_subnet_group" "secondary" {
  provider = aws.us_west_2

  name       = "aurora-secondary-subnet-group"
  subnet_ids = var.secondary_subnets

  tags = {
    Name = "aurora-secondary-subnet-group"
  }
}
