# modules/vpc/versions.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.80" # Specify the version you want to use
    }
  }
}
