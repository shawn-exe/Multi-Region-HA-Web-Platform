#This file has the IAM policies defined for Terraform to access S3 and DynamoDB

data "aws_iam_policy_document" "tf_state_access" {
  # List buckets (needed for backend init)
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.tf_state.arn]
  }

  # Read and write state files
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["${aws_s3_bucket.tf_state.arn}/*"]
  }

  # Acquire and release DynamoDB locks
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]
    resources = [aws_dynamodb_table.tf_locks.arn]
  }

  # KMS — only needed if using aws:kms encryption
  statement {
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt",
    ]
    resources = ["*"]  # scope to your KMS key ARN in prod
  }
}

resource "aws_iam_policy" "tf_state_access" {
  name   = "terraform-state-access"
  policy = data.aws_iam_policy_document.tf_state_access.json
}