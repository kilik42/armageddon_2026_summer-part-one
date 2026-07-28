locals {
  name_prefix = lower("${var.project_name}-${var.environment}")

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Component   = "Lambda"
  }
}

# ============================================================
# Package Lambda source files
# ============================================================

data "archive_file" "analyzer" {
  type        = "zip"
  source_file = "${var.lambda_source_dir}/waf_analyzer.py"
  output_path = "${path.module}/waf_analyzer.zip"
}

data "archive_file" "correlation" {
  type        = "zip"
  source_file = "${var.lambda_source_dir}/threat_correlation.py"
  output_path = "${path.module}/threat_correlation.zip"
}

data "archive_file" "soar" {
  type        = "zip"
  source_file = "${var.lambda_source_dir}/soar_response.py"
  output_path = "${path.module}/soar_response.zip"
}

data "archive_file" "dashboard" {
  type        = "zip"
  source_file = "${var.lambda_source_dir}/executive_dashboard.py"
  output_path = "${path.module}/executive_dashboard.zip"
}

# ============================================================
# WAF Analyzer Lambda
# ============================================================

resource "aws_lambda_function" "analyzer" {
  function_name = "${local.name_prefix}-waf-analyzer"
  description   = "Analyzes AWS WAF logs and stores normalized security events"

  role    = var.analyzer_role_arn
  handler = "waf_analyzer.lambda_handler"
  runtime = "python3.12"

  filename         = data.archive_file.analyzer.output_path
  source_code_hash = data.archive_file.analyzer.output_base64sha256

  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory_size

  environment {
    variables = {
      AWS_REGION_NAME    = var.aws_region
      WAF_LOG_GROUP_NAME = var.waf_log_group_name
      WAF_EVENTS_TABLE   = var.waf_events_table_name
      ENABLE_BEDROCK     = tostring(var.enable_bedrock)
      BEDROCK_MODEL_ID   = var.bedrock_model_id
      LOG_LEVEL          = var.log_level
    }
  }

  tags = merge(local.common_tags, {
    Name     = "${local.name_prefix}-waf-analyzer"
    Function = "WAFAnalyzer"
  })
}

# ============================================================
# Threat Correlation Lambda
# ============================================================

resource "aws_lambda_function" "correlation" {
  function_name = "${local.name_prefix}-threat-correlation"
  description   = "Correlates normalized WAF events into security findings"

  role    = var.correlation_role_arn
  handler = "threat_correlation.lambda_handler"
  runtime = "python3.12"

  filename         = data.archive_file.correlation.output_path
  source_code_hash = data.archive_file.correlation.output_base64sha256

  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory_size

  environment {
    variables = {
      AWS_REGION_NAME            = var.aws_region
      WAF_EVENTS_TABLE           = var.waf_events_table_name
      CORRELATION_FINDINGS_TABLE = var.correlation_findings_table_name
      LOG_LEVEL                  = var.log_level
    }
  }

  tags = merge(local.common_tags, {
    Name     = "${local.name_prefix}-threat-correlation"
    Function = "ThreatCorrelationAgent"
  })
}

# ============================================================
# SOAR Response Lambda
# ============================================================

resource "aws_lambda_function" "soar" {
  function_name = "${local.name_prefix}-soar-response"
  description   = "Executes deterministic incident-response playbooks"

  role    = var.soar_role_arn
  handler = "soar_response.lambda_handler"
  runtime = "python3.12"

  filename         = data.archive_file.soar.output_path
  source_code_hash = data.archive_file.soar.output_base64sha256

  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory_size

  environment {
    variables = {
      AWS_REGION_NAME            = var.aws_region
      CORRELATION_FINDINGS_TABLE = var.correlation_findings_table_name
      SECURITY_INCIDENTS_TABLE   = var.security_incidents_table_name
      SNS_TOPIC_ARN              = var.sns_topic_arn
      ENABLE_BEDROCK             = tostring(var.enable_bedrock)
      BEDROCK_MODEL_ID           = var.bedrock_model_id
      LOG_LEVEL                  = var.log_level
    }
  }

  tags = merge(local.common_tags, {
    Name     = "${local.name_prefix}-soar-response"
    Function = "SOARResponseAgent"
  })
}

# ============================================================
# Executive Dashboard Lambda
# ============================================================

resource "aws_lambda_function" "dashboard" {
  function_name = "${local.name_prefix}-executive-dashboard"
  description   = "Generates executive security reports and uploads them to S3"

  role    = var.dashboard_role_arn
  handler = "executive_dashboard.lambda_handler"
  runtime = "python3.12"

  filename         = data.archive_file.dashboard.output_path
  source_code_hash = data.archive_file.dashboard.output_base64sha256

  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory_size

  environment {
    variables = {
      AWS_REGION_NAME            = var.aws_region
      CORRELATION_FINDINGS_TABLE = var.correlation_findings_table_name
      SECURITY_INCIDENTS_TABLE   = var.security_incidents_table_name
      REPORTS_BUCKET_NAME        = var.reports_bucket_name
      ENABLE_BEDROCK             = tostring(var.enable_bedrock)
      BEDROCK_MODEL_ID           = var.bedrock_model_id
      LOG_LEVEL                  = var.log_level
    }
  }

  tags = merge(local.common_tags, {
    Name     = "${local.name_prefix}-executive-dashboard"
    Function = "ExecutiveDashboardAgent"
  })
}