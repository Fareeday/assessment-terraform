variable "db_username" {
  type        = string
  description = "The master username for the database"
  default     = "admin"
}

variable "db_password" {
  type        = string
  description = "The master password for the database"
  sensitive   = true
}

variable "db_instance_class" {
  type        = string
  description = "The instance type for the Aurora cluster"
  default     = "db.r5.large"
}

variable "primary_subnets" {
  type        = list(string)
  description = "The subnets for the primary Aurora cluster"
}

variable "secondary_subnets" {
  type        = list(string)
  description = "The subnets for the secondary Aurora cluster"
}

variable "security_group_id" {
  type        = string
  description = "The security group ID for the Aurora cluster"
}
