# Terraform module for managing an S3 bucket used for executive reports
data "aws_caller_identity" "current" {}


# Local values for bucket naming and common tags
locals {
  name_prefix = lower("${var.project_name}-${var.environment}")

  bucket_name = lower(
    replace(
      "${local.name_prefix}-executive-reports-${data.aws_caller_identity.current.account_id}",
      "_",
      "-"
    )
  )

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Component   = "S3"
  }
}


# S3 bucket resource for executive reports
resource "aws_s3_bucket" "executive_reports" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy

  tags = local.common_tags
}


# S3 bucket public access block configuration for executive reports
resource "aws_s3_bucket_public_access_block" "executive_reports" {
  bucket = aws_s3_bucket.executive_reports.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket ownership controls for executive reports
resource "aws_s3_bucket_ownership_controls" "executive_reports" {
  bucket = aws_s3_bucket.executive_reports.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# S3 bucket server-side encryption configuration for executive reports
resource "aws_s3_bucket_server_side_encryption_configuration" "executive_reports" {
  bucket = aws_s3_bucket.executive_reports.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }

    bucket_key_enabled = true
  }
}

# S3 bucket versioning configuration for executive reports
resource "aws_s3_bucket_versioning" "executive_reports" {
  bucket = aws_s3_bucket.executive_reports.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket lifecycle configuration for executive reports
resource "aws_s3_bucket_lifecycle_configuration" "executive_reports" {
  bucket = aws_s3_bucket.executive_reports.id

  depends_on = [
    aws_s3_bucket_versioning.executive_reports
  ]

  rule {
    id     = "expire-executive-reports"
    status = "Enabled"

    filter {
      prefix = "executive-reports/"
    }

    expiration {
      days = var.report_retention_days
    }

    noncurrent_version_expiration {
      noncurrent_days = var.report_retention_days
    }
  }
}