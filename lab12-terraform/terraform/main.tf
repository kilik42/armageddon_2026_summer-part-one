module "dynamodb" {
  source = "./modules/dynamodb"

  project_name = var.project_name
  environment  = var.environment
}

module "s3" {
  source = "./modules/s3"

  project_name          = var.project_name
  environment           = var.environment
  report_retention_days = var.report_retention_days
  force_destroy         = var.environment != "prod"
}

module "sns" {
  source = "./modules/sns"

  project_name       = var.project_name
  environment        = var.environment
  notification_email = var.notification_email
}

module "waf" {
  source = "./modules/waf"

  project_name = var.project_name
  environment  = var.environment

  scope             = "REGIONAL"
  enable_rate_limit = true
  rate_limit        = 2000
}


module "logging" {
  source = "./modules/logging"

  project_name       = var.project_name
  environment        = var.environment
  web_acl_arn        = module.waf.web_acl_arn
  log_retention_days = var.log_retention_days
}


module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

 # this part is for passing resource ARNs to the IAM module
  waf_log_group_arn              = module.logging.waf_log_group_arn
  waf_events_table_arn           = module.dynamodb.waf_events_table_arn


  # this part is for passing DynamoDB table ARNs to the IAM module
  correlation_findings_table_arn = module.dynamodb.correlation_findings_table_arn
  security_incidents_table_arn   = module.dynamodb.security_incidents_table_arn

  sns_topic_arn      = module.sns.topic_arn
  reports_bucket_arn = module.s3.bucket_arn

  enable_bedrock   = var.enable_bedrock
  bedrock_model_id = var.bedrock_model_id
}
module "lambdas" {
  source = "./modules/lambdas"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  lambda_source_dir = "${path.root}/lambda_src"

  analyzer_role_arn    = module.iam.analyzer_role_arn
  correlation_role_arn = module.iam.correlation_role_arn
  soar_role_arn        = module.iam.soar_role_arn
  dashboard_role_arn   = module.iam.dashboard_role_arn

  waf_log_group_name             = module.logging.waf_log_group_name
  waf_events_table_name          = module.dynamodb.waf_events_table_name
  correlation_findings_table_name = module.dynamodb.correlation_findings_table_name
  security_incidents_table_name   = module.dynamodb.security_incidents_table_name

  sns_topic_arn      = module.sns.topic_arn
  reports_bucket_name = module.s3.bucket_name

  enable_bedrock   = var.enable_bedrock
  bedrock_model_id = var.bedrock_model_id
}