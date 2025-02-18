
output "vpc_us_east_1_id" {
  value = module.vpc_us_east_1.vpc_id
}

output "public_subnet_us_east_1_ids" {
  value = module.vpc_us_east_1.public_subnet_ids
}

output "private_subnet_us_east_1_ids" {
  value = module.vpc_us_east_1.private_subnet_ids
}

output "vpc_us_west_2_id" {
  value = module.vpc_us_west_2.vpc_id
}

output "public_subnet_us_west_2_ids" {
  value = module.vpc_us_west_2.public_subnet_ids
}

output "private_subnet_us_west_2_ids" {
  value = module.vpc_us_west_2.private_subnet_ids
}

output "ecs_cluster_east_1_name" {
  value = module.ecs_cluster_east_1.ecs_cluster_name
}

output "ecs_service_east_1_name" {
  value = module.ecs_cluster_east_1.ecs_service_name
}

output "ecs_cluster_west_2_name" {
  value = module.ecs_cluster_west_2.ecs_cluster_name
}

output "ecs_service_west_2_name" {
  value = module.ecs_cluster_west_2.ecs_service_name
}

output  "ecs_security_group_id"  {
  value = module.security_group.ecs_security_group_id
}
/*# Outputs for S3 Buckets
output "primary_bucket_name" {
  value = module.s3_east_1.bucket_name
}

output "primary_bucket_regional_domain_name" {
  value = module.s3_east_1.bucket_regional_domain_name
}

output "failover_bucket_name" {
  value = module.s3_west_2.bucket_name
}

output "failover_bucket_regional_domain_name" {
  value = module.s3_west_2.bucket_regional_domain_name
}

# Output for CloudFront
output "cloudfront_domain_name" {
  value = module.cloudfront.cloudfront_domain_name
}*/
