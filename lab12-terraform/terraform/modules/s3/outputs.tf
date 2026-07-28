output "report_bucket_name" {
  description = "Name of the S3 bucket used for executive reports"
  value       = aws_s3_bucket.executive_reports.bucket
}

output "report_bucket_arn" {
  description = "ARN of the S3 bucket used for executive reports"
  value       = aws_s3_bucket.executive_reports.arn
}

output "report_bucket_id" {
  description = "ID of the S3 bucket used for executive reports"
  value       = aws_s3_bucket.executive_reports.id
}

output "executive_reports_prefix" {
  description = "S3 prefix used for executive reports"
  value       = "executive-reports/"
}

output "bucket_arn" {
  value = aws_s3_bucket.executive_reports.arn
}

