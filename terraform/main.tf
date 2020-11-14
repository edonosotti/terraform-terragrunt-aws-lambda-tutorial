provider "aws" {
  region                  = var.aws_region
  # shared_credentials_file = "~/.aws/credentials"
  profile                 = var.aws_profile
}

terraform {
  required_version = ">= 0.13.5"

  required_providers {
    archive = "~> 2.0.0"
    aws = "~> 3.15.0"
    null = "~> 3.0.0"
    random = "~> 3.0.0"
  }
}
