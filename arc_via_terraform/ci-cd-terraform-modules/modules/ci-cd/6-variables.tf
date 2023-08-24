variable "env" {
  type = string
  default = "staging"
}
variable "app_name" {
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
variable "git_username" {
  type = string
}
variable "git_repo" {
  type = string
}
variable "git_token" {
  type = string
}
variable "repo_branch" {
  type = string
  default = "main"
}
variable "solution_stack_name" {
  type = string
  default = "64bit Amazon Linux 2 v5.8.2 running Node.js 14"    
}
variable "application_tier" {
  type = string
  default = "WebServer"
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "environment_type" {
  type = string
  default = "SingleInstance"    # Update with "LoadBalanced" if you want a load-balanced environment
}
variable "s3_bucket_name" {
  type = string
  default = "demmo503"
}
variable "environment_variables" {
  type = map(string)
  # default = {
  #   "ENV_VAR_1" = "Value1"
  #   "ENV_VAR_2" = "Value2"
  #   "ENV_VAR_3" = "Value3"
  #   # Add more environment variables here
  # }
}
variable "minsize" {
  type = number
  default = 1
}
variable "maxsize" {
  type = number
  default = 3
}
variable "vpc_id" {
    description = "ID of the VPC"
}
variable "public_subnet_ids" {
  
}
variable "private_subnet_ids" {
  
}
variable "iam_role_arn" {
  
}
variable "key_pair_name" {
  description = "Name of the EC2 key pair"
}
variable "load_balancer_type" {
  type = string
}