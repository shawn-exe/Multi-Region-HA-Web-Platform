#This File has the bootstap bundle which includes S3 bucket, DynamoDB, access_control and versioning

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # Local backend — intentional. We're creating the remote backend here.
  backend "local" {}
}

provider "aws" {
  region = "us-east-1"
}

locals {
  project     = "multi-region-ha"
  environment = "shared"
}

# ── S3 State Bucket ──────────────────────────────────────────

resource "aws_s3_bucket" "tf_state" {
  bucket = "${local.project}-tfstate-${data.aws_caller_identity.current.account_id}"

  lifecycle {
    prevent_destroy = false # prevents accidental deletion
  }

  tags = {
    Name        = "Terraform state"
    Environment = local.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled" # recover from corrupt/accidental state
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms" # or "AES256" for simplicity
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90 # keep 90 days of old state versions
    }
  }
}

# ── DynamoDB Lock Table ──────────────────────────────────────

resource "aws_dynamodb_table" "tf_locks" {
  name         = "${local.project}-tf-locks"
  billing_mode = "PAY_PER_REQUEST" # no capacity planning needed
  hash_key     = "LockID"          # Terraform requires exactly this name

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name        = "Terraform state locks"
    Environment = local.environment
    ManagedBy   = "terraform"
  }
}

# ── Data sources & Outputs ───────────────────────────────────

data "aws_caller_identity" "current" {}

output "state_bucket_name" {
  value = aws_s3_bucket.tf_state.bucket
}

output "lock_table_name" {
  value = aws_dynamodb_table.tf_locks.name
}