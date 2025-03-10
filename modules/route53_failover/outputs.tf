output "primary_route53_record" {
  value = aws_route53_record.primary.fqdn
}

output "secondary_route53_record" {
  value = aws_route53_record.secondary.fqdn
}

output "health_check_id" {
  value = aws_route53_health_check.primary_alb.id
}

