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