# Outputs for the DynamoDB tables created in this module
output "waf_events_table_name" {
  description = "Name of the WAF events DynamoDB table"
  value       = aws_dynamodb_table.waf_events.name
}

# output table arn for the WAF events table
output "waf_events_table_arn" {
  description = "ARN of the WAF events DynamoDB table"
  value       = aws_dynamodb_table.waf_events.arn
}

# output table name for the correlation findings table
output "correlation_findings_table_name" {
  description = "Name of the correlation findings DynamoDB table"
  value       = aws_dynamodb_table.correlation_findings.name
}

# output table arn for the correlation findings table
output "correlation_findings_table_arn" {
  description = "ARN of the correlation findings DynamoDB table"
  value       = aws_dynamodb_table.correlation_findings.arn
}

## output table name for the security incidents table
output "security_incidents_table_name" {
  description = "Name of the security incidents DynamoDB table"
  value       = aws_dynamodb_table.security_incidents.name
}

## output table arn for the security incidents table
output "security_incidents_table_arn" {
  description = "ARN of the security incidents DynamoDB table"
  value       = aws_dynamodb_table.security_incidents.arn
}