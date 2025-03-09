# This Is Modules/Ecs_Service/Variables.tf

variable "service_name" {
  description = "The name of the ECS Service"
  type        = string
  default     = "nginx-service"
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "task_definition" {
  description = "The name of the TASK Definition"
  type        = string
}

variable "subnets" {
  description = "Subnets for ECS Service"
  type        = list(string)
}

variable "security_group_id" {
  description = "The security group ID for the ECS service"
  type        = string
}

variable "target_group_arn" {
  description = "Target Group ARN"
  type        = string
}

variable "container_name" {
  description = "The name of the Container"
  type        = string
}

variable "container_port" {
  description = "Container Port"
  type        = string
}

