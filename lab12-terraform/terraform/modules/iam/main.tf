locals {
  name_prefix = lower("${var.project_name}-${var.environment}")

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Component   = "IAM"
  }
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

# ------------------------------------------------------------
# Lambda trust policy
# ------------------------------------------------------------

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    sid     = "LambdaAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# ============================================================
# Analyzer Lambda role
# ============================================================

resource "aws_iam_role" "analyzer" {
  name               = "${local.name_prefix}-analyzer-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = merge(local.common_tags, {
    Function = "WAFBedrockAnalyzer"
  })
}

data "aws_iam_policy_document" "analyzer" {
  statement {
    sid    = "ReadWAFLogs"
    effect = "Allow"

    actions = [
      "logs:DescribeLogStreams",
      "logs:FilterLogEvents",
      "logs:GetLogEvents",
      "logs:StartQuery",
      "logs:GetQueryResults",
      "logs:StopQuery"
    ]

    resources = [
      var.waf_log_group_arn,
      "${var.waf_log_group_arn}:*"
    ]
  }

  statement {
    sid    = "WriteWAFEvents"
    effect = "Allow"

    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:GetItem"
    ]

    resources = [
      var.waf_events_table_arn
    ]
  }

  dynamic "statement" {
    for_each = var.enable_bedrock ? [1] : []

    content {
      sid    = "InvokeBedrock"
      effect = "Allow"

      actions = [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream"
      ]

      resources = [
        "arn:${data.aws_partition.current.partition}:bedrock:${var.aws_region}::foundation-model/${var.bedrock_model_id}"
      ]
    }
  }
}

resource "aws_iam_role_policy" "analyzer" {
  name   = "${local.name_prefix}-analyzer-policy"
  role   = aws_iam_role.analyzer.id
  policy = data.aws_iam_policy_document.analyzer.json
}

# ============================================================
# Correlation Lambda role
# ============================================================

resource "aws_iam_role" "correlation" {
  name               = "${local.name_prefix}-correlation-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = merge(local.common_tags, {
    Function = "WAFThreatCorrelationAgent"
  })
}

data "aws_iam_policy_document" "correlation" {
  statement {
    sid    = "ReadWAFEvents"
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]

    resources = [
      var.waf_events_table_arn,
      "${var.waf_events_table_arn}/index/*"
    ]
  }

  statement {
    sid    = "ManageCorrelationFindings"
    effect = "Allow"

    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]

    resources = [
      var.correlation_findings_table_arn,
      "${var.correlation_findings_table_arn}/index/*"
    ]
  }

  statement {
    sid    = "PublishFindingEvent"
    effect = "Allow"

    actions = [
      "events:PutEvents"
    ]

    resources = var.event_bus_arn == null ? ["*"] : [
      var.event_bus_arn
    ]
  }
}

resource "aws_iam_role_policy" "correlation" {
  name   = "${local.name_prefix}-correlation-policy"
  role   = aws_iam_role.correlation.id
  policy = data.aws_iam_policy_document.correlation.json
}

# ============================================================
# SOAR Lambda role
# ============================================================

resource "aws_iam_role" "soar" {
  name               = "${local.name_prefix}-soar-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = merge(local.common_tags, {
    Function = "SOARResponseAgent"
  })
}

data "aws_iam_policy_document" "soar" {
  statement {
    sid    = "ReadAndUpdateFindings"
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:Query"
    ]

    resources = [
      var.correlation_findings_table_arn,
      "${var.correlation_findings_table_arn}/index/*"
    ]
  }

  statement {
    sid    = "ManageSecurityIncidents"
    effect = "Allow"

    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:Query"
    ]

    resources = [
      var.security_incidents_table_arn,
      "${var.security_incidents_table_arn}/index/*"
    ]
  }

  statement {
    sid    = "PublishSecurityAlert"
    effect = "Allow"

    actions = [
      "sns:Publish"
    ]

    resources = [
      var.sns_topic_arn
    ]
  }

  dynamic "statement" {
    for_each = var.enable_bedrock ? [1] : []

    content {
      sid    = "InvokeBedrock"
      effect = "Allow"

      actions = [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream"
      ]

      resources = [
        "arn:${data.aws_partition.current.partition}:bedrock:${var.aws_region}::foundation-model/${var.bedrock_model_id}"
      ]
    }
  }
}

resource "aws_iam_role_policy" "soar" {
  name   = "${local.name_prefix}-soar-policy"
  role   = aws_iam_role.soar.id
  policy = data.aws_iam_policy_document.soar.json
}

# ============================================================
# Executive Dashboard Lambda role
# ============================================================

resource "aws_iam_role" "dashboard" {
  name               = "${local.name_prefix}-dashboard-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = merge(local.common_tags, {
    Function = "ExecutiveDashboardAgent"
  })
}

data "aws_iam_policy_document" "dashboard" {
  statement {
    sid    = "ReadCorrelationFindings"
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]

    resources = [
      var.correlation_findings_table_arn,
      "${var.correlation_findings_table_arn}/index/*"
    ]
  }

  statement {
    sid    = "ReadSecurityIncidents"
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]

    resources = [
      var.security_incidents_table_arn,
      "${var.security_incidents_table_arn}/index/*"
    ]
  }

  statement {
    sid    = "WriteExecutiveReports"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:AbortMultipartUpload"
    ]

    resources = [
      "${var.reports_bucket_arn}/*"
    ]
  }

  statement {
    sid    = "ListExecutiveReportsBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      var.reports_bucket_arn
    ]
  }

  dynamic "statement" {
    for_each = var.enable_bedrock ? [1] : []

    content {
      sid    = "InvokeBedrock"
      effect = "Allow"

      actions = [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream"
      ]

      resources = [
        "arn:${data.aws_partition.current.partition}:bedrock:${var.aws_region}::foundation-model/${var.bedrock_model_id}"
      ]
    }
  }
}

resource "aws_iam_role_policy" "dashboard" {
  name   = "${local.name_prefix}-dashboard-policy"
  role   = aws_iam_role.dashboard.id
  policy = data.aws_iam_policy_document.dashboard.json
}

# ============================================================
# Basic Lambda CloudWatch logging permissions
# ============================================================

resource "aws_iam_role_policy_attachment" "analyzer_basic_execution" {
  role       = aws_iam_role.analyzer.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "correlation_basic_execution" {
  role       = aws_iam_role.correlation.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "soar_basic_execution" {
  role       = aws_iam_role.soar.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "dashboard_basic_execution" {
  role       = aws_iam_role.dashboard.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}