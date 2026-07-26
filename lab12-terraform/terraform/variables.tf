variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

## Project and Environment Variables
variable "project_name" {
  description = "The name of the project"
  type        = string

  default     = "armageddon_summer_2026"
}

variable "environment" {
  description = "The environment for the resources (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

#### waf_log_group
variable "waf_log_group" {
  description = "cloudwatch log group for WAF logs"
  type        = string
  default     = "waf-log-group"
}


# bedrock configuration

variable "enable_bedrock" {
  description = "Enable or disable Bedrock configuration"
  type        = bool
  default     = true # Set to true to enable Bedrock configuration by default
}

variable "bedrock_model_id"{
  description = "Amazon bedrock model ID"
  type        = string
  default     = "amazon.nova-lite-v1:0"
}


###sns notifications

variable "notification_email"{
    description = "Email address for SNS notifications"
    type        = string
    default     = ""
}

# Analyzer Settings
# in this section, we define variables related to the log analysis settings

#log minutes for analysis. this is for determining the time range of logs to be analyzed
variable "lookback_minutes"{
    description = "The number of minutes to look back for analysis"
    type        = number
    default     = 5
}

# this section defines the maximum number of log events to retrieve for analysis
variable "max_log_events"{
    description = "The maximum number of log events to retrieve for analysis"
    type        = number
    default     = 1000
}

# Correlation Settings
# in this section, we define variables related to the correlation of log events
variable "correlation_window_minutes"{
    description = "The time window in minutes for correlating log events"
    type        = number
    default     = 60
}

variable "minimum_event_count" {
  description = "Minimum events before creating a finding"
  type        = number
  default     = 3
}

variable "max_events" {
  description = "Maximum events to analyze"
  type        = number
  default     = 1000
}

# Executive Dashboard
variable "report_retention_days" {
  description = "How long reports remain in S3"
  type        = number
  default     = 30
}