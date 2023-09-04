provider "aws" {
  region  = var.aws_region
  profile = var.aws_cli_profile
  default_tags {
    tags = {
      Name = "poc1"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.13.1"
    }
  }
}