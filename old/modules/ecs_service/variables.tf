variable "cluster_name" {
  type        = string
  description = "The name of the ECS cluster"
}

variable "service_name" {
  type        = string
  description = "The name of the ECS service"
}

variable "task_definition" {
  type        = string
  description = "The ARN of the ECS task definition"
}

variable "target_group_arn" {
  type        = string
  description = "The ARN of the ALB target group"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "subnets" {
  type        = list(string)
  description = "The subnets for the ECS service"
}

variable  "container_name"  {
  type        = string
  description = "The name of the container"
}

variable  "container_port"  {
  type        = string
  description = "Port on which container listens"
}

variable  "security_group_id"  {
  type        = string
  description = "Security Group to attch the ECS Service"
}
