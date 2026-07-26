locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Component   = "SNS"
  }
}

resource "aws_sns_topic" "security_alerts" {
  name = "${local.name_prefix}-security-alerts"

  tags = local.common_tags
}

resource "aws_sns_topic_subscription" "security_email" {
  count = var.notification_email != "" ? 1 : 0

  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}