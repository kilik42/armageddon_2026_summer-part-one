output "waf_events_table_name" {
  description = "Name of the WAF events DynamoDB table"
  value       = aws_dynamodb_table.waf_events.name
}

output "waf_events_table_arn" {
  description = "ARN of the WAF events DynamoDB table"
  value       = aws_dynamodb_table.waf_events.arn
}

output "correlation_findings_table_name" {
  description = "Name of the correlation findings DynamoDB table"
  value       = aws_dynamodb_table.correlation_findings.name
}

output "correlation_findings_table_arn" {
  description = "ARN of the correlation findings DynamoDB table"
  value       = aws_dynamodb_table.correlation_findings.arn
}

output "security_incidents_table_name" {
  description = "Name of the security incidents DynamoDB table"
  value       = aws_dynamodb_table.security_incidents.name
}

output "security_incidents_table_arn" {
  description = "ARN of the security incidents DynamoDB table"
  value       = aws_dynamodb_table.security_incidents.arn
}