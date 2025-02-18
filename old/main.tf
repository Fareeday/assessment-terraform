# VPC Modules For 2 Regions
module "vpc_us_east_1" {
  source = "./modules/vpc"

  providers = {
    aws = aws.us_east_1
  }

  cidr_block = "10.0.0.0/16"
  vpc_name   = "vpc-us-east-1"

  public_subnets = [
    { cidr = "10.0.1.0/24", az = "us-east-1a", name = "public-subnet-1" },
    { cidr = "10.0.2.0/24", az = "us-east-1b", name = "public-subnet-2" }
  ]

  private_subnets = [
    { cidr = "10.0.3.0/24", az = "us-east-1a", name = "private-subnet-1" },
    { cidr = "10.0.4.0/24", az = "us-east-1b", name = "private-subnet-2" }
  ]
}

module "vpc_us_west_2" {
  source = "./modules/vpc"

  providers = {
    aws = aws.us_west_2
  }

  cidr_block = "10.1.0.0/16"
  vpc_name   = "vpc-us-west-2"

  public_subnets = [
    { cidr = "10.1.1.0/24", az = "us-west-2a", name = "public-subnet-1" },
    { cidr = "10.1.2.0/24", az = "us-west-2b", name = "public-subnet-2" }
  ]

  private_subnets = [
    { cidr = "10.1.3.0/24", az = "us-west-2a", name = "private-subnet-1" },
    { cidr = "10.1.4.0/24", az = "us-west-2b", name = "private-subnet-2" }
  ]
}

#SG
module "security_group" {
  source = "./modules/security_group"

  providers = {
    aws = aws.us_east_1
  }

  security_group_name        = "web-sg"
  security_group_description = "Security group for web traffic (HTTP/HTTPS)"
  vpc_id                     = module.vpc_us_east_1.vpc_id # Replace with your VPC ID

  depends_on = [module.vpc_us_east_1]
}

module "web_security_group2" {
  source = "./modules/security_group"

  providers = {
    aws = aws.us_west_2
  }

  security_group_name        = "web-sg"
  security_group_description = "Security group for web traffic (HTTP/HTTPS)"
  vpc_id                     = module.vpc_us_west_2.vpc_id # Replace with your VPC ID
}

#ECS 
module "ecs_cluster_east_1" {
  source = "./modules/ecs"

  providers = {
    aws = aws.us_east_1
  }

  region                 = "us-east-1"
  ecs_cluster_name       = "ExampleSite-ecs-cluster"
  task_definition_family = "ExampleSite-task-definition_east-1"
  task_cpu               = 256
  task_memory            = 512
  container_name         = "ExampleSite"
  container_image        = "nginx:latest"
  container_port         = 80
  ecs_service_name       = "ExampleSite-ecs-service_east-1"
  desired_count          = 1
  subnets                = module.vpc_us_east_1.public_subnet_ids
  security_group_id      = module.security_group.security_group_id

  depends_on = [module.vpc_us_east_1]
}

module "ecs_cluster_west_2" {
  source = "./modules/ecs"

  providers = {
    aws = aws.us_west_2
  }

  region                 = "us-west-2"
  ecs_cluster_name       = "ExampleSite-ecs-cluster"
  task_definition_family = "ExampleSite-task-definition_west-2"
  task_cpu               = 256
  task_memory            = 512
  container_name         = "ExampleSite"
  container_image        = "nginx:latest"
  container_port         = 80
  ecs_service_name       = "ExampleSite-ecs-service_west-2"
  desired_count          = 1
  subnets                = module.vpc_us_west_2.public_subnet_ids
  security_group_id      = module.security_group.security_group_id 

  depends_on = [module.vpc_us_west_2]
}

# ALB for ECS in us-east-1
module "alb_east_1" {
  source = "./modules/alb"

  providers = {
    aws = aws.us_east_1
  }

  alb_name    = "alb-east-1"
  vpc_id      = module.vpc_us_east_1.vpc_id
  subnets     = module.vpc_us_east_1.public_subnet_ids
  target_port = 80
  security_group_id = module.security_group.alb_security_group_id
}

# ALB for ECS in us-west-2
module "alb_west_2" {
  source = "./modules/alb"

  providers = {
    aws = aws.us_west_2
  }

  alb_name    = "alb-west-2"
  vpc_id      = module.vpc_us_west_2.vpc_id
  subnets     = module.vpc_us_west_2.public_subnet_ids
  target_port = 80
  security_group_id = module.security_group.alb_security_group_id
}

# Attach ALB to ECS Service in us-east-1
module "ecs_service_east_1" {
  source = "./modules/ecs_service"

  providers = {
    aws = aws.us_east_1
  }

  #cluster_name = module.ecs_east_1.cluster_name
  cluster_name = "ExampleSite-ecs-cluster"
  service_name = "ecs-service-east-1"
  task_definition = module.ecs_cluster_east_1.task_definition_arn
  #task_definition = "ExampleSite-Task"
  target_group_arn = module.alb_east_1.target_group_arn
  vpc_id      = module.vpc_us_east_1.vpc_id
  subnets     = module.vpc_us_east_1.public_subnet_ids
  #security_group_id  = module.security_group.ecs_security_group_id
  security_group_id      = module.security_group.ecs_security_group_id 
  container_name     = module.ecs_cluster_east_1.container_name
  container_port     = 80

}

# Attach ALB to ECS Service in us-west-2
module "ecs_service_west_2" {
  source = "./modules/ecs_service"

  providers = {
    aws = aws.us_west_2
  }

  #cluster_name = module.ecs_west_2.cluster_name
  cluster_name = "ExampleSite-ecs-cluster"
  service_name = "ecs-service-west-2"
  task_definition = module.ecs_cluster_west_2.task_definition_arn
  #task_definition = "ExampleSite-Task"
  target_group_arn = module.alb_west_2.target_group_arn
  vpc_id      = module.vpc_us_west_2.vpc_id
  subnets     = module.vpc_us_west_2.public_subnet_ids
  #security_group_id  = module.security_group.ecs_security_group_id
  security_group_id      = module.security_group.ecs_security_group_id 
  container_name     = module.ecs_cluster_east_1.container_name
  container_port     = 80

}

# RDS Security Group in us-east-1
module "rds_security_group_east_1" {
  source = "./modules/security_group"

  providers = {
    aws = aws.us_east_1
  }

  security_group_name        = "rds-sg-east-1"
  security_group_description = "Security group for RDS in us-east-1"
  vpc_id                     = module.vpc_us_east_1.vpc_id
  allowed_cidr_blocks        = ["10.0.0.0/16"] # Allow access from the VPC
  depends_on = [module.vpc_us_east_1]
}

# RDS Security Group in us-west-2
module "rds_security_group_west_2" {
  source = "./modules/security_group"

  providers = {
    aws = aws.us_west_2
  }

  security_group_name        = "rds-sg-west-2"
  security_group_description = "Security group for RDS in us-west-2"
  vpc_id                     = module.vpc_us_west_2.vpc_id
  allowed_cidr_blocks        = ["10.1.0.0/16"] # Allow access from the VPC
  depends_on = [module.vpc_us_west_2]
}

/*#Aurora

# Aurora Global Database
module "aurora_global_db" {
  source = "./modules/aurora"

  providers = {
    aws = aws.us_east_1
    aws.us_west_2 = aws.us_west_2
  }

  db_username         = "admin"
  db_password         = "MySecurePassword123!"
  db_instance_class   = "db.r5.large"
  primary_subnets     = module.vpc_us_east_1.private_subnet_ids
  secondary_subnets   = module.vpc_us_west_2.private_subnet_ids
  security_group_id   = module.rds_security_group_east_1.security_group_id
}*/

/*#RDS

# RDS in us-east-1
module "rds_east_1" {
  source = "./modules/rds"

  providers = {
    aws = aws.us_east_1
  }

  db_instance_identifier = "rds-east-1"
  db_engine              = "mysql"
  db_engine_version      = "8.0"
  db_instance_class      = "db.t3.micro"
  allocated_storage      = 20
  db_username            = "admin"
  db_password            = "MySecurePassword123!"
  subnets                = module.vpc_us_east_1.private_subnet_ids
  security_group_id      = module.rds_security_group_east_1.security_group_id
  multi_az               = true
}

# RDS in us-west-2
module "rds_west_2" {
  source = "./modules/rds"

  providers = {
    aws = aws.us_west_2
  }

  db_instance_identifier =  "rds-west-2"
  db_engine              = "mysql"
  db_engine_version      = "8.0"
  db_instance_class      = "db.t3.micro"
  allocated_storage      = 20
  db_username            = "admin"
  db_password            = "MySecurePassword123!"
  subnets                = module.vpc_us_west_2.private_subnet_ids
  security_group_id      = module.rds_security_group_west_2.security_group_id
  multi_az               = true
}*/


# S3 Bucket

# S3 Bucket in us-east-1
module "s3_east_1" {
  source = "./modules/s3"

  providers = {
    aws = aws.us_east_1
  }

  bucket_name = "examplesite-bucket-east-1"
  file_path   = "index.html"
}

# S3 Bucket in us-west-2
module "s3_west_2" {
  source = "./modules/s3"

  providers = {
    aws = aws.us_west_2
  }

  bucket_name = "examplesite-bucket-west-2"
  file_path   = "index.html"
}

# CloudFront Distribution
module "cloudfront" {
  source = "./modules/cloudfront"

  primary_bucket_regional_domain_name  = module.s3_east_1.bucket_regional_domain_name
  failover_bucket_regional_domain_name = module.s3_west_2.bucket_regional_domain_name
}
