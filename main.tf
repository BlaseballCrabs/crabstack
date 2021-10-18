terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "iam_role" {
  type = string
}

provider "aws" {
  region      = var.region
  assume_role = var.iam_role
}
