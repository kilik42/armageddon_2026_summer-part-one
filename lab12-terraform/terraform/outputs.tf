output "waf_events_table_name" {
  description = "Name of the WAF events table"
  value       = module.dynamodb.waf_events_table_name
}

# waf events store analyzed waf requests 

output "correlation_findings_table_name" {
  description = "Name of the correlation findings table"
  value       = module.dynamodb.correlation_findings_table_name
}

# correlation findings store the results of correlating different security events

# security incidents store detected security incidents
output "security_incidents_table_name" {
  description = "Name of the security incidents table"
  value       = module.dynamodb.security_incidents_table_name
}

## s3
output "report_bucket_name" {
  description = "Name of the executive reports S3 bucket"
  value       = module.s3.report_bucket_name
}

output "report_bucket_arn" {
  description = "ARN of the executive reports S3 bucket"
  value       = module.s3.report_bucket_arn
}


#sns
output "security_alerts_topic_arn" {
  description = "ARN of the SNS security alerts topic"
  value       = module.sns.topic_arn
}

output "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = module.waf.web_acl_arn
}

output "waf_web_acl_name" {
  description = "Name of the WAF Web ACL"
  value       = module.waf.web_acl_name
}