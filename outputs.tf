output "alb_dns_name_east" {
  description = "The name of the ALB in us-east-1"
  value       = module.alb-east.alb_dns_name
}

output "alb_dns_name_west" {
  description = "The name of the ALB in us-west-2"
  value       = module.alb-west.alb_dns_name
}

