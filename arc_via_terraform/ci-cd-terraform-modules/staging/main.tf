terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}
terraform {
  backend "local" {
    path = "modules/terraform.tfstate"
  }
}

module "iam_role" {
  source     = "../modules/IAM_Role" # Replace this with the correct path to the "vpc" module
  aws_region = "ap-southeast-2"
  env        = "staging"
  access_key = ""
  secret_key = ""
}

module "vpc" {
  source          = "../modules/vpc"
  access_key      = ""
  secret_key      = ""
  env             = "luxe-lottries-staging"
  aws_region      = "ap-southeast-2"
  azs             = ["ap-southeast-2a", "ap-southeast-2b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "cloudfront-1" {
  source      = "../modules/cloudfront-s3-using-tf"
  access_key  = ""
  secret_key  = ""
  environment = "staging"
  bucket_name = "luxe-admin-stag"
}

module "cloudfront-2" {
  source      = "../modules/cloudfront-s3-using-tf"
  access_key  = ""
  secret_key  = ""
  environment = "staging"
  bucket_name = "luxe-poker-stag"
}

module "cloudfront-3" {
  source      = "../modules/cloudfront-s3-using-tf"
  access_key  = ""
  secret_key  = ""
  environment = "staging"
  bucket_name = "luxe-roulette-stag"
}

module "cloudfront-4" {
  source      = "../modules/cloudfront-s3-using-tf"
  access_key  = ""
  secret_key  = ""
  environment = "staging"
  bucket_name = "luxe-slot-game-stag"
}

module "cloudfront-5" {
  source      = "../modules/cloudfront-s3-using-tf"
  access_key  = ""
  secret_key  = ""
  environment = "staging"
  bucket_name = "luxe-web-stag"
}

module "cloudfront-6" {
  source      = "../modules/cloudfront-s3-using-tf"
  access_key  = ""
  secret_key  = ""
  environment = "staging"
  bucket_name = "luxe-wof-stag"
}

module "ci-cd-1" {
  source              = "../modules/ci-cd"
  private_subnet_ids  = module.vpc.private_subnet_ids
  public_subnet_ids   = module.vpc.public_subnet_ids
  vpc_id              = module.vpc.vpc_id
  iam_role_arn        = module.iam_role.iam_role_arn
  key_pair_name       = "test"
  access_key          = ""
  secret_key          = ""
  git_username        = ""
  git_repo            = ""
  git_token           = ""
  repo_branch         = "staging"
  env                 = "staging"
  app_name            = "admin-server-luxe-lottries"
  load_balancer_type  = "application"
  aws_region          = "ap-southeast-2"
  s3_bucket_name      = "admin-server-luxe-lottries-stag"
  solution_stack_name = "64bit Amazon Linux 2 v5.8.4 running Node.js 18"
  application_tier    = "WebServer"
  instance_type       = "t2.micro"
  environment_type    = "LoadBalanced"
  environment_variables = {
    "NODE_ENV"               = "staging"
    "PLATFORM"               = "Casino"
  }
  minsize = 1
  maxsize = 2
}


module "ci-cd-2" {
  source              = "../modules/ci-cd"
  private_subnet_ids  = module.vpc.private_subnet_ids
  public_subnet_ids   = module.vpc.public_subnet_ids
  vpc_id              = module.vpc.vpc_id
  iam_role_arn        = module.iam_role.iam_role_arn
  key_pair_name       = "test"
  access_key          = ""
  secret_key          = ""
  git_username        = ""
  git_repo            = ""
  git_token           = ""
  repo_branch         = "staging"
  env                 = "staging"
  app_name            = "web-server-luxe-lottries"
  load_balancer_type  = "application"
  aws_region          = "ap-southeast-2"
  s3_bucket_name      = "web-server-luxe-lottries-stag"
  solution_stack_name = "64bit Amazon Linux 2 v5.8.4 running Node.js 18"
  application_tier    = "WebServer"
  instance_type       = "t2.micro"
  environment_type    = "LoadBalanced"
  environment_variables = {
    "NODE_ENV"               = "staging"
    "PLATFORM"               = "Casino"
  }
  minsize = 1
  maxsize = 2
}

module "ci-cd-3" {
  source              = "../modules/ci-cd"
  private_subnet_ids  = module.vpc.private_subnet_ids
  public_subnet_ids   = module.vpc.public_subnet_ids
  vpc_id              = module.vpc.vpc_id
  iam_role_arn        = module.iam_role.iam_role_arn
  key_pair_name       = "test"
  access_key          = ""
  secret_key          = ""
  git_username        = ""
  git_repo            = ""
  git_token           = ""
  repo_branch         = "staging"
  env                 = "staging"
  app_name            = "websocket-luxe-lottries"
  load_balancer_type  = "network"
  aws_region          = "ap-southeast-2"
  s3_bucket_name      = "websocket-server-luxe-lottries-stag"
  solution_stack_name = "64bit Amazon Linux 2 v5.8.4 running Node.js 18"
  application_tier    = "WebServer"
  instance_type       = "t2.micro"
  environment_type    = "LoadBalanced"
  environment_variables = {
    "NODE_ENV"               = "staging"
    "PLATFORM"               = "Casino"
    "SERVER_TYPE"            = ""

  }
  minsize = 1
  maxsize = 2
}

