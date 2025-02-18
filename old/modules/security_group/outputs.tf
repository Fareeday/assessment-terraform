output "security_group_id" {
  value = aws_security_group.this.id
}

output "ecs_security_group_id" {
  value = aws_security_group.this.id
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

