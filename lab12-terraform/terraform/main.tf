module "dynamodb" {
  source = "./modules/dynamodb"

  project_name = var.project_name
  environment  = var.environment
}

module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  environment  = var.environment
}

module "sns" {
  source = "./modules/sns"

  project_name = var.project_name
  environment  = var.environment
  notification_email = var.notification_email
}