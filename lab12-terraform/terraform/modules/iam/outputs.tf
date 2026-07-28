output "analyzer_role_name" {
  description = "Name of the WAF analyzer Lambda execution role"
  value       = aws_iam_role.analyzer.name
}

output "analyzer_role_arn" {
  description = "ARN of the WAF analyzer Lambda execution role"
  value       = aws_iam_role.analyzer.arn
}

output "correlation_role_name" {
  description = "Name of the correlation Lambda execution role"
  value       = aws_iam_role.correlation.name
}

output "correlation_role_arn" {
  description = "ARN of the correlation Lambda execution role"
  value       = aws_iam_role.correlation.arn
}

output "soar_role_name" {
  description = "Name of the SOAR Lambda execution role"
  value       = aws_iam_role.soar.name
}

output "soar_role_arn" {
  description = "ARN of the SOAR Lambda execution role"
  value       = aws_iam_role.soar.arn
}

output "dashboard_role_name" {
  description = "Name of the executive dashboard Lambda execution role"
  value       = aws_iam_role.dashboard.name
}

output "dashboard_role_arn" {
  description = "ARN of the executive dashboard Lambda execution role"
  value       = aws_iam_role.dashboard.arn
}