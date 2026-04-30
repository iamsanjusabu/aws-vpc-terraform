terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.43"
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
