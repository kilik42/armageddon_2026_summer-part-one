# so i am making three tables: waf_events, correlation_findings, and security_incidents
# all tables will have point-in-time recovery enabled based on the variable setting

# i make the local files here to define common naming and tagging conventions for the DynamoDB tables
locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Component   = "DynamoDB"
  }
}

resource "aws_dynamodb_table" "waf_events" {
  name         = "${local.name_prefix}-waf-events"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "event_id"

  attribute {
    name = "event_id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  tags = local.common_tags
}

resource "aws_dynamodb_table" "correlation_findings" {
  name         = "${local.name_prefix}-waf-correlation-findings"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "finding_id"

  attribute {
    name = "finding_id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  tags = local.common_tags
}

resource "aws_dynamodb_table" "security_incidents" {
  name         = "${local.name_prefix}-security-incidents"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "incident_id"

  attribute {
    name = "incident_id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  tags = local.common_tags
}