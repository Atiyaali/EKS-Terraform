terraform {
    required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.26"
    }
  }

  backend "s3" {
    bucket         = "atiyaalitfstatefile"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    # use_lock =     true
    # dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}