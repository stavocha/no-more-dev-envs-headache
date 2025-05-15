output "crossplane_role_arn" {
  description = "ARN of the IAM role for Crossplane"
  value       = aws_iam_role.crossplane_aws_role.arn
} 