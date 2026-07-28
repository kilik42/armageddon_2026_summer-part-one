locals {
  name_prefix = lower("${var.project_name}-${var.environment}")

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Component   = "Logging"
  }
}

resource "aws_cloudwatch_log_group" "waf_logs" {
  # AWS WAF log-group names must begin with aws-waf-logs-
  name              = "aws-waf-logs-${local.name_prefix}"
  retention_in_days = var.log_retention_days

  tags = merge(local.common_tags, {
    Name = "aws-waf-logs-${local.name_prefix}"
  })
}

resource "aws_wafv2_web_acl_logging_configuration" "this" {
  resource_arn = var.web_acl_arn

  log_destination_configs = [
    aws_cloudwatch_log_group.waf_logs.arn
  ]

  redacted_fields {
    single_header {
      name = "authorization"
    }
  }

  redacted_fields {
    single_header {
      name = "cookie"
    }
  }
}