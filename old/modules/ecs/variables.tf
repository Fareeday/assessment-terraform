variable "region" {
  type        = string
  description = "The AWS region where the ECS cluster is deployed"
}

variable "ecs_cluster_name" {
  type        = string
  description = "The name of the ECS cluster"
}

variable "task_definition_family" {
  type        = string
  description = "The family name for the ECS task definition"
}

variable "task_cpu" {
  type        = number
  description = "The CPU units for the ECS task"
  default     = 256
}

variable "task_memory" {
  type        = number
  description = "The memory for the ECS task"
  default     = 512
}

variable "container_name" {
  type        = string
  description = "The name of the container"
}

variable "container_image" {
  type        = string
  description = "The Docker image for the container"
}

variable "container_port" {
  type        = number
  description = "The port on which the container listens"
}

variable "ecs_service_name" {
  type        = string
  description = "The name of the ECS service"
}

variable "desired_count" {
  type        = number
  description = "The desired number of tasks to run"
  default     = 1
}

variable "subnets" {
  type        = list(string)
  description = "The subnets for the ECS service"
}

variable "security_group_id" {
  type        = string
  description = "The security group ID for the ECS service"
}
