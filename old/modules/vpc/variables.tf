# modules/vpc/variables.tf
variable "cidr_block" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "public_subnets" {
  type = list(object({
    cidr = string
    az   = string
    name = string
  }))
}

variable "private_subnets" {
  type = list(object({
    cidr = string
    az   = string
    name = string
  }))
}
