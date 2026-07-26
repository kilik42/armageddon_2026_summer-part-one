variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment, such as dev, test, or prod"
  type        = string
}

# this is for enabling point-in-time recovery on the DynamoDB tables
# this allows you to restore the table to any point in time within the retention period
variable "enable_point_in_time_recovery" {
  description = "Enable point-in-time recovery for the DynamoDB tables"
  type        = bool
  default     = true
}