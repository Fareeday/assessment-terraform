terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.80" # Specify the version you want to use
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  alias   = "us_east_1"
  profile = "sameer"
}

provider "aws" {
  region  = "us-west-2"
  alias   = "us_west_2"
  profile = "sameer"
}

