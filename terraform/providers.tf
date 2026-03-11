terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = "us-east-2"
}

provider "github" {
  owner = "enpicie" # Roles are setup specifically for use in this org
}
