variable "security_group_name" {
  type        = string
  description = "The name of the security group"
}

variable "security_group_description" {
  type        = string
  description = "The description of the security group"
  default     = "Security group for HTTP and HTTPS traffic"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the security group will be created"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access RDS"
  default     = ["0.0.0.0/0"] # Restrict this to specific IPs in production
}
