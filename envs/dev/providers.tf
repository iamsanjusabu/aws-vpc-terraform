terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.43"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.8"
    }
  }

  backend "local" {
    path = "../../state-files/terraform.tfstate"
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "terraform"
}
