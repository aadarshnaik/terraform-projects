terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.70.0"
    }
  }

  # backend "s3" {
  #   bucket = "remote-backend-s3-tws"
  #   key = "terraform.tfstate"
  #   region = "us-east-1"
  #   dynamodb_table = "tws-learning-state-table"
  # }
  
}