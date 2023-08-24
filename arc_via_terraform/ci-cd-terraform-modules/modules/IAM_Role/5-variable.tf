variable "env" {
  type = string
}
variable "aws_region" {
  type = string
  default = "us-east-1"
}
variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}
output "iam_role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.codepipeline_role.arn
}
# output "aws_autoscaling_policy" {
#   description = "The ARN of the IAM role"
#   value       = aws_autoscaling_policy.sample_policy.arn
# }