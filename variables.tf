variable "service_name" {
  description = "ECS Service name"
  type        = string
}

variable "cluster_name" {
  description = "ECS Service name"
  type        = string
}

variable "container_name" {
  description = "ECS container name"
  type        = string
}

variable "container_port" {
  description = "ECS Service name"
  type        = string
  default     = 80
}

variable "target_port" {
  description = "ECS Service name"
  type        = string
  default     = 80
}

variable "alb_name" {
  description = "ECS Service name"
  type        = string
}

variable "image_name" {
  description = "ECS Service name"
  type        = string
}
