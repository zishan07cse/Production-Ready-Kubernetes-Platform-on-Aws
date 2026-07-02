terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote backend example for team usage.
  # Create the S3 bucket and DynamoDB table before enabling this block.
  # Never commit terraform.tfstate files to GitHub.
  #
  # backend "s3" {
  #   bucket         = "REPLACE_WITH_TERRAFORM_STATE_BUCKET"
  #   key            = "devops-assessment/dev/eks/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "REPLACE_WITH_TERRAFORM_LOCK_TABLE"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(var.tags, {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    })
  }
}
