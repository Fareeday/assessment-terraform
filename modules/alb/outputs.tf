output "target_group_arn" {
  description = "The ARN of the ALB target group"
  value       = aws_lb_target_group.this.arn
}

