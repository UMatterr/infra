terraform {
  cloud {
    organization = "semi-project"
    workspaces {
      name = "umatter-web"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}
