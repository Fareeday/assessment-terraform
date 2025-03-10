# This is ROOT main.tf
# Define AWS Providers for Two Regions
provider "aws" {
  alias   = "east"
  region  = "us-east-1"
  profile = "sameer"
}

provider "aws" {
  alias   = "west"
  region  = "us-west-2"
  profile = "sameer"
}

/*****************************************************************
                             VPC
*****************************************************************/
# Deploy VPC in US-EAST-1
module "vpc_east" {
  source = "./modules/vpc"

  providers = {
    aws = aws.east
  }

  vpc_name   = "vpc-east"
  cidr_block = "10.0.0.0/16"
  public_subnets = [
    { cidr = "10.0.1.0/24", az = "us-east-1a", name = "public-subnet-1a" },
    { cidr = "10.0.2.0/24", az = "us-east-1b", name = "public-subnet-1b" }
  ]
  private_subnets = [
    { cidr = "10.0.3.0/24", az = "us-east-1a", name = "private-subnet-1a" },
    { cidr = "10.0.4.0/24", az = "us-east-1b", name = "private-subnet-1b" }
  ]
}

# Deploy VPC in US-WEST-2
module "vpc_west" {
  source = "./modules/vpc"

  providers = {
    aws = aws.west
  }

  vpc_name   = "vpc-west"
  cidr_block = "10.1.0.0/16"
  public_subnets = [
    { cidr = "10.1.1.0/24", az = "us-west-2a", name = "public-subnet-2a" },
    { cidr = "10.1.2.0/24", az = "us-west-2b", name = "public-subnet-2b" }
  ]
  private_subnets = [
    { cidr = "10.1.3.0/24", az = "us-west-2a", name = "private-subnet-2a" },
    { cidr = "10.1.4.0/24", az = "us-west-2b", name = "private-subnet-2b" }
  ]
}

/*****************************************************************
                            END-VPC
*****************************************************************/
/*****************************************************************
                         SECURITY-GROUP
*****************************************************************/
# Security Group For US-EAST-1
module "security_group_east" {
  source = "./modules/security_group"

  providers = {
    aws = aws.east
  }

  env    = "dev"
  vpc_id = module.vpc_east.vpc_id
}

# Security Group For US-WEST-2

module "security_group_west" {
  source = "./modules/security_group"

  providers = {
    aws = aws.west
  }

  env    = "dev"
  vpc_id = module.vpc_west.vpc_id
}
/*****************************************************************
                    END-SECURITY-GROUP
*****************************************************************/
/*****************************************************************
                    IAM-ROLE
*****************************************************************/
module "iam" {
  source = "./modules/iam"

  providers = {
    aws = aws.east
  }

  source_bucket      = "my-s0urc3-buck3t"
  destination_bucket = "my-d3st1nat1on-buck3t"
}

/*****************************************************************
                    END-IAM-ROLE
*****************************************************************/
/*****************************************************************
                             ALB
*****************************************************************/
#ALB FOR US-EAST
module "alb-east" {
  source = "./modules/alb"

  providers = {
    aws = aws.east
  }

  alb_name          = "${var.alb_name}-alb"
  target_port       = var.target_port
  vpc_id            = module.vpc_east.vpc_id
  subnets           = module.vpc_east.public_subnet_ids
  security_group_id = module.security_group_east.alb_security_group_id
}

#ALB FOR US-WEST
module "alb-west" {
  source = "./modules/alb"

  providers = {
    aws = aws.west
  }

  alb_name          = "${var.alb_name}-alb"
  target_port       = var.target_port
  vpc_id            = module.vpc_west.vpc_id
  subnets           = module.vpc_west.public_subnet_ids
  security_group_id = module.security_group_west.alb_security_group_id
}
/*****************************************************************
                          END-ALB
*****************************************************************/
/*****************************************************************
                        ECS-CLUSTER
*****************************************************************/
# ECS CLUSTER FOR US-EAST
module "ecs_cluster-east" {
  source = "./modules/ecs_cluster"

  providers = {
    aws = aws.east
  }

  cluster_name   = "${var.cluster_name}_nginx-cluster"
  container_name = var.container_name
  image_name     = var.image_name
  #iam_role_arn   = module.iam.iam_role_arn
  iam_role_arn = module.iam.ecs_task_execution_role_arn
}

# ECS CLUSTER FOR US-WEST
module "ecs_cluster-west" {
  source = "./modules/ecs_cluster"

  providers = {
    aws = aws.west
  }

  cluster_name   = "${var.cluster_name}_nginx-cluster"
  container_name = var.container_name
  image_name     = var.image_name
  #iam_role_arn   = module.iam.iam_role_arn
  iam_role_arn = module.iam.ecs_task_execution_role_arn
}

/*****************************************************************
                       END-ECS-CLUSTER
*****************************************************************/
/*****************************************************************
                        ECS-SERVICE
*****************************************************************/
#ECS SERVICE FOR US-EAST
module "ecs_service-east" {
  source = "./modules/ecs_service"

  providers = {
    aws = aws.east
  }

  service_name      = "${var.service_name}-ecs-svc"
  cluster_name      = module.ecs_cluster-east.ecs_cluster_name
  task_definition   = module.ecs_cluster-east.ecs_task_definition_arn
  subnets           = module.vpc_east.public_subnet_ids
  security_group_id = module.security_group_east.ecs_security_group_id
  container_name    = var.container_name
  container_port    = var.container_port
  target_group_arn  = module.alb-east.target_group_arn
  #iam_role_name     = module.iam.ecs_task_execution_role_name

  depends_on = [module.alb-east]
}

#ECS SERVICE FOR US-WEST
module "ecs_service-west" {
  source = "./modules/ecs_service"

  providers = {
    aws = aws.west
  }

  service_name      = "${var.service_name}-ecs-svc"
  cluster_name      = module.ecs_cluster-west.ecs_cluster_name
  task_definition   = module.ecs_cluster-west.ecs_task_definition_arn
  subnets           = module.vpc_west.public_subnet_ids
  security_group_id = module.security_group_west.ecs_security_group_id
  container_name    = var.container_name
  container_port    = var.container_port
  target_group_arn  = module.alb-west.target_group_arn
  #iam_role_name     = module.iam.ecs_task_execution_role_name

  depends_on = [module.alb-west]
}

/*****************************************************************
                     END-ECS-SERVICE
*****************************************************************/

/*****************************************************************
                          RDS
*****************************************************************/
module "rds_east" {
  source = "./modules/rds"

  providers = {
    aws = aws.east
  }

  db_instance_identifier = "rds-east"
  db_engine              = "mysql"
  db_engine_version      = "8.0"
  db_instance_class      = "db.t3.micro"
  allocated_storage      = 20
  db_username            = "admin"
  db_password            = "MySecurePassword123!"
  subnets                = module.vpc_east.private_subnet_ids
  security_group_id      = module.security_group_east.rds_security_group_id
  multi_az               = true
}

module "rds_west" {
  source = "./modules/rds"

  providers = {
    aws = aws.west
  }

  db_instance_identifier = "rds-west"
  db_engine              = "mysql"
  db_engine_version      = "8.0"
  db_instance_class      = "db.t3.micro"
  allocated_storage      = 20
  db_username            = "admin"
  db_password            = "MySecurePassword123!"
  subnets                = module.vpc_west.private_subnet_ids
  security_group_id      = module.security_group_west.rds_security_group_id
  multi_az               = true
}

/*****************************************************************
                        END-RDS
*****************************************************************/
/*****************************************************************
                            S3
*****************************************************************/

# S3 Source Bucket in us-east-1
module "s3_source" {
  source = "./modules/s3"

  providers = {
    aws = aws.east
  }

  bucket_name  = "my-s0urc3-buck3t"
  iam_role_arn = module.iam.iam_role_arn
}

# S3 Destination Bucket in us-west-2
module "s3_destination" {
  source = "./modules/s3"

  providers = {
    aws = aws.west
  }

  bucket_name  = "my-d3st1nat1on-buck3t"
  iam_role_arn = module.iam.iam_role_arn
}

# Replication Configuration (Only applied to the source bucket)
module "s3_replication" {
  source = "./modules/s3_replication"

  providers = {
    aws = aws.east
  }

  source_bucket                 = module.s3_source.bucket_name
  destination_bucket_arn        = module.s3_destination.bucket_arn
  iam_role_arn                  = module.iam.iam_role_arn
  source_bucket_depends_on      = module.s3_source
  destination_bucket_depends_on = module.s3_destination
}


/*****************************************************************
                          END - S3
*****************************************************************/

/*****************************************************************
                         CloudFront
*****************************************************************/
module "cloudfront" {
  source = "./modules/cloudfront"

  source_bucket_regional_domain_name      = module.s3_source.bucket_regional_domain_name
  destination_bucket_regional_domain_name = module.s3_destination.bucket_regional_domain_name
}


/*****************************************************************
                    END - CloudFront
*****************************************************************/

/*****************************************************************
                         Route53
*****************************************************************/
/*module "route53_failover" {
  source = "./modules/route53_failover"

  hosted_zone_id       = var.hosted_zone_id
  domain_name          = "example.com"
  primary_alb_dns      = module.alb-east.alb_dns_name
  primary_alb_zone_id  = module.alb-east.alb_zone_id
  secondary_alb_dns    = module.alb-west.alb_dns_name
  secondary_alb_zone_id = module.alb-west.alb_zone_id
}
*/
