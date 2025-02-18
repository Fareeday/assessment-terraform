variable "alb_name" {
  type        = string
  description = "The name of the ALB"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "subnets" {
  type        = list(string)
  description = "The subnets for the ALB"
}

variable "target_port" {
  type        = number
  description = "The target port for the ALB"
}

variable  "security_group_id"  {
  type        = string
  description = "Security Group to attch the ECS Service"
}
