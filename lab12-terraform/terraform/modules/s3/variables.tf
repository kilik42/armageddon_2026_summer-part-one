variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment, such as dev, test, or prod"
  type        = string
}

variable "report_retention_days" {
  description = "Number of days to keep executive reports in S3"
  type        = number
  default     = 90

  validation {
    condition     = var.report_retention_days > 0
    error_message = "report_retention_days must be greater than 0."
  }
}

variable "force_destroy" {
  description = "Allow Terraform to delete the bucket even when it contains objects"
  type        = bool
  default     = false
}