output "analyzer_function_name" {
  description = "Name of the WAF analyzer Lambda"
  value       = aws_lambda_function.analyzer.function_name
}

output "analyzer_function_arn" {
  description = "ARN of the WAF analyzer Lambda"
  value       = aws_lambda_function.analyzer.arn
}

output "correlation_function_name" {
  description = "Name of the threat correlation Lambda"
  value       = aws_lambda_function.correlation.function_name
}

output "correlation_function_arn" {
  description = "ARN of the threat correlation Lambda"
  value       = aws_lambda_function.correlation.arn
}

output "soar_function_name" {
  description = "Name of the SOAR response Lambda"
  value       = aws_lambda_function.soar.function_name
}

output "soar_function_arn" {
  description = "ARN of the SOAR response Lambda"
  value       = aws_lambda_function.soar.arn
}

output "dashboard_function_name" {
  description = "Name of the executive dashboard Lambda"
  value       = aws_lambda_function.dashboard.function_name
}

output "dashboard_function_arn" {
  description = "ARN of the executive dashboard Lambda"
  value       = aws_lambda_function.dashboard.arn
}