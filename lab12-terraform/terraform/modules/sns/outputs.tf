output "topic_name" {
  description = "Name of the SNS security alerts topic"
  value       = aws_sns_topic.security_alerts.name
}

output "topic_arn" {
  description = "ARN of the SNS security alerts topic"
  value       = aws_sns_topic.security_alerts.arn
}

# output "topic_arn" {
#   value = aws_sns_topic.security_alerts.arn
# }