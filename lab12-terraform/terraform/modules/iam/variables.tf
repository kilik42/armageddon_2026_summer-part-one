variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region used by the project"
  type        = string
}

variable "waf_log_group_arn" {
  description = "ARN of the CloudWatch log group containing WAF logs"
  type        = string
}

variable "waf_events_table_arn" {
  description = "ARN of the waf-events DynamoDB table"
  type        = string
}

variable "correlation_findings_table_arn" {
  description = "ARN of the waf-correlation-findings DynamoDB table"
  type        = string
}

variable "security_incidents_table_arn" {
  description = "ARN of the security-incidents DynamoDB table"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS security alerts topic"
  type        = string
}

variable "reports_bucket_arn" {
  description = "ARN of the S3 executive reports bucket"
  type        = string
}

variable "event_bus_arn" {
  description = "ARN of the EventBridge event bus"

  type    = string
  default = null
}

variable "enable_bedrock" {
  description = "Whether Lambda functions can invoke Amazon Bedrock"
  type        = bool
  default     = true
}

variable "bedrock_model_id" {
  description = "Amazon Bedrock model ID used by the Lambda functions"
  type        = string
}