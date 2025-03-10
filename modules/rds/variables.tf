variable "db_instance_identifier" {
  type        = string
  description = "The identifier for the RDS instance"
}

variable "db_engine" {
  type        = string
  description = "The database engine (e.g., mysql, aurora)"
  default     = "mysql"
}

variable "db_engine_version" {
  type        = string
  description = "The database engine version"
  default     = "8.0"
}

variable "db_instance_class" {
  type        = string
  description = "The instance type for the RDS instance"
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  description = "The allocated storage in GB"
  default     = 20
}

variable "storage_type" {
  type        = string
  description = "The storage type (e.g., gp2, io1)"
  default     = "gp2"
}

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

variable "subnets" {
  type        = list(string)
  description = "The subnets for the RDS subnet group"
}

variable "security_group_id" {
  type        = string
  description = "The security group ID for the RDS instance"
}

variable "backup_retention_period" {
  type        = number
  description = "The number of days to retain backups"
  default     = 7
}

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment"
  default     = false
}
