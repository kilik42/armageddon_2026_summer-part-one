variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "scope" {
  description = "WAF scope: REGIONAL for API Gateway/ALB or CLOUDFRONT for CloudFront"
  type        = string
  default     = "REGIONAL"

  validation {
    condition     = contains(["REGIONAL", "CLOUDFRONT"], var.scope)
    error_message = "scope must be either REGIONAL or CLOUDFRONT."
  }
}

variable "enable_rate_limit" {
  description = "Enable the rate-based WAF rule"
  type        = bool
  default     = true
}

variable "rate_limit" {
  description = "Maximum requests allowed per five-minute evaluation window"
  type        = number
  default     = 2000

  validation {
    condition     = var.rate_limit > 0
    error_message = "rate_limit must be greater than 0."
  }
}