terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-tue181"
    key            = "terraform.tfstate"
    region         = "eu-east-1"
    dynamodb_table = "tfstate-locking"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
