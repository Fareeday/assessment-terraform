# This Is Root variables.tf

variable "service_name" {
  description = "ECS Service Name"
  type        = string
  default     = "ExampleService"
}

variable "cluster_name" {
  description = "ECS Cluster Name"
  type        = string
  default     = "ExampleCluster"
}

variable "container_name" {
  description = "ECS Conntainer Name"
  type        = string
  default     = "ExampleContainer"
}

variable "container_port" {
  description = "ECS Container Port Number"
  type        = string
  default     = 80
}

variable "target_port" {
  description = "ECS Target Port Number"
  type        = string
  default     = 80
}

variable "alb_name" {
  description = "ALB Name"
  type        = string
  default     = "ExampleLB"
}

variable "image_name" {
  description = "ECS Container Image Name"
  type        = string
  default     = "nginx:latest"
}

variable "hosted_zone_id" {
  type        = string
  description = "The Route 53 hosted zone ID"
}

