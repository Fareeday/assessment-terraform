# This Is Modules/ALB/Variables.tf

variable  "vpc_id"  {
  description = "VPC ID where the ALB will be deployed"
  type        = string
}

variable  "subnets"  {
  description = "List of subnets for the ALB"
  type        = list(string)
}

variable  "security_group_id"  {
  description = "Security Group ID to associate with ALB"
  type        = string
}

variable  "alb_name"  {
  description = "Security Group ID to associate with ALB"
  type        = string
}

variable  "target_port"  {
  description = "Security Group ID to associate with ALB"
  type        = string
}
