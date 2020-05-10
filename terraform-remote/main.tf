terraform {
  required_providers {
    aws = "~> 2.57.0"
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_s3_bucket" "remote_state_bucket" {
  bucket = "iac-env-state-${terraform.workspace}"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
