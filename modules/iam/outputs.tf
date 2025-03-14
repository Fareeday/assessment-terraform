# This Is Modules/IAM/Outputs.tf

output  "iam_role_name"  {
  description = "The Name of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.name
}

#output "iam_role_arn" {
output "ecs_task_execution_role_arn" {
  description = "The ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "iam_role_arn" {
  value = aws_iam_role.s3_replication_role.arn
}

