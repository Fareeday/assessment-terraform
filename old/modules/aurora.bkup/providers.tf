terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.80"
    }
    # aws.us_east_1 = {
    #  source  = "hashicorp/aws"
    #  version = ">= 5.80"
    #}
    #aws.us_west_2 = {
    #  source  = "hashicorp/aws"
    #  version = ">= 5.80"
    #}
  }
}
