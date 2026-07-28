variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "lambda_source_dir" {
  description = "Directory containing the Lambda Python files"
  type        = string
}

variable "analyzer_role_arn" {
  description = "IAM role ARN for the WAF analyzer Lambda"
  type        = string
}

variable "correlation_role_arn" {
  description = "IAM role ARN for the correlation Lambda"
  type        = string
}

variable "soar_role_arn" {
  description = "IAM role ARN for the SOAR Lambda"
  type        = string
}

variable "dashboard_role_arn" {
  description = "IAM role ARN for the dashboard Lambda"
  type        = string
}

variable "waf_log_group_name" {
  description = "CloudWatch log group containing WAF logs"
  type        = string
}

variable "waf_events_table_name" {
  description = "Name of the WAF events DynamoDB table"
  type        = string
}

variable "correlation_findings_table_name" {
  description = "Name of the correlation findings DynamoDB table"
  type        = string
}

variable "security_incidents_table_name" {
  description = "Name of the security incidents DynamoDB table"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS security alerts topic"
  type        = string
}

variable "reports_bucket_name" {
  description = "Name of the executive reports bucket"
  type        = string
}

variable "enable_bedrock" {
  description = "Whether Bedrock integration is enabled"
  type        = bool
  default     = true
}

variable "bedrock_model_id" {
  description = "Amazon Bedrock model ID"
  type        = string
}

variable "lambda_timeout" {
  description = "Default Lambda timeout in seconds"
  type        = number
  default     = 60
}

variable "lambda_memory_size" {
  description = "Default Lambda memory in MB"
  type        = number
  default     = 256
}

variable "log_level" {
  description = "Lambda application log level"
  type        = string
  default     = "INFO"
}

