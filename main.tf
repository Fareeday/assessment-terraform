# This is ROOT main.tf
# Define AWS Providers for Two Regions
provider "aws" {
  alias  = "east"
  region = "us-east-1"
  profile = "sameer"
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
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

  vpc_name      = "vpc-east"
  cidr_block    = "10.0.0.0/16"
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

  vpc_name      = "vpc-west"
  cidr_block    = "10.1.0.0/16"
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

module "security_group_west" {
  source = "./modules/security_group"

  providers = {
    aws = aws.west
  }

  env    = "dev"
  vpc_id = module.vpc_west.vpc_id
}

# Security Group For US-WEST-2

/*****************************************************************
                    END-SECURITY-GROUP
*****************************************************************/
/*****************************************************************
                             ALB
*****************************************************************/
module "alb" {
  source = "./modules/alb"

  providers = {
    aws = aws.east
  }

  alb_name            = "${var.alb_name}-alb"
  target_port         = var.target_port
  vpc_id              = module.vpc_east.vpc_id
  subnets             = module.vpc_east.public_subnet_ids
  security_group_id   = module.security_group_east.alb_security_group_id
}

/*****************************************************************
                          END-ALB
*****************************************************************/
/*****************************************************************
                        ECS-CLUSTER
*****************************************************************/

module "ecs_cluster" {
  source = "./modules/ecs_cluster"

  providers = {
    aws = aws.east
  }

  cluster_name       = "${var.cluster_name}_nginx-cluster"
  container_name     = var.container_name
  image_name         = var.image_name
}

/*****************************************************************
                       END-ECS-CLUSTER
*****************************************************************/
/*****************************************************************
                        ECS-SERVICE
*****************************************************************/

module "ecs_service" {
  source = "./modules/ecs_service"

  providers = {
    aws = aws.east
  }

  service_name      = "${var.service_name}-ecs-svc"
  cluster_name      = module.ecs_cluster.ecs_cluster_name
  task_definition   = module.ecs_cluster.ecs_task_definition_arn
  subnets           = module.vpc_east.public_subnet_ids
  security_group_id = module.security_group_east.ecs_security_group_id
  container_name    = var.container_name
  container_port    = var.container_port
  target_group_arn  = module.alb.target_group_arn

  depends_on        = [module.alb]
}

/*****************************************************************
                     END-ECS-SERVICE
*****************************************************************/

/*****************************************************************
                          RDS
*****************************************************************/
module "rds" {
  source = "./modules/rds"

  providers = {
    aws = aws.east
  }
}

/*****************************************************************
                        END-RDS
*****************************************************************/
/*****************************************************************
                            S3
*****************************************************************/
