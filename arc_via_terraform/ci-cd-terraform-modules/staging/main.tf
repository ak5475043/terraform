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
  git_username        = "Colin-Mackenzie-Slots"
  git_repo            = "Luxe_Lotteries_Admin_Backend_NodeJs"
  git_token           = "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"
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
    "SERVER_TYPE"            = ""
    "SERVER_HOST"            = "0.0.0.0"
    "SERVER_PORT"            = "8080"
    "SERVER_PROTOCOL"        = "http"
    "SERVER_URL"             = "http://localhost:8080"
    "USER_DEFAULT_PASSWORD"  = "@UserPassword@1"
    "DB_PROTOCOL"            = "mongodb"
    "DB_HOST"                = "127.0.0.1"
    "DB_PORT"                = "27017"
    "DB_NAME"                = ""
    "DB_USER"                = ""
    "DB_PASS"                = ""
    "DB_URL"                 = "mongodb+srv://justin:osk7mvsXG0xDgBAS@luxe-staging.vzeoad0.mongodb.net/casino_stag"
    "AWS_ACCESS_KEY_ID"      = "AKIAS6KORSRP74HLKLIG"
    "AWS_SECRET_ACESS_KEY"   = "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"
    "AWS_REGION"             = "ap-southeast-2"
    "S3_BUCKET_NAME"         = "backend-resource-staging"
    "CLOUDFRONT_URL"         = "https://assets-staging.theluxelottery.com"
    "UPLOAD_TO_S3_BUCKET"    = "true"
    "NODEMAILER_HOST"        = "smtp-relay.sendinblue.com"
    "NODEMAILER_USER"        = "prateekjain.091@gmail.com"
    "NODEMAILER_PASSWORD"    = "2MnsVhFxSEzjAwLR"
    "SENDER_NAME"            = "Prateek"
    "SENDER_EMAIL"           = "luxcasino@gmail.com"
    "NODEMAILER_PORT"        = "587"
    "SUPER_ADMIN_EMAIL"      = "superadmin@yopmail.com"
    "SUPER_ADMIN_PASS"       = "@Pk12345"
    "SUPER_ADMIN_NAME"       = "Colin"
    "SUPER_ADMIN_FIRST_NAME" = "Super"
    "SUPER_ADMIN_LAST_NAME"  = "Admin"
    "SWAGGER_AUTH_USERNAME"  = "chicmic"
    "SWAGGER_AUTH_PASSWORD"  = "chicmic"
    "API_AUTH_KEY"           = "7HLsBfaH6b2YR7nw"
    "REDIS_PORT"             = ""
    "REDIS_HOST"             = ""
    "REDIS_PASSWORD"         = ""
    "PINO_API_KEY"           = "SIkke2o97VSS"
    "PINO_API_SECRET"        = "81e8c3a2-a9d3-4d7b-b2a1-2fe6e164353b"
    "WEB_URL"                = "https://web-staging.theluxelottery.com"
    "ADMIN_WEB_URL"          = "https://admin-staging.theluxelottery.com"

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
  git_username        = "Colin-Mackenzie-Slots"
  git_repo            = "Luxe_Lotteries_Backend_NodeJs"
  git_token           = "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"
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
    "SERVER_TYPE"            = ""
    "SERVER_HOST"            = "0.0.0.0"
    "SERVER_PORT"            = "8080"
    "SERVER_PROTOCOL"        = "http"
    "SERVER_URL"             = "http://localhost:8080"
    "DB_PROTOCOL"            = "mongodb"
    "DB_HOST"                = "127.0.0.1"
    "DB_PORT"                = "27017"
    "DB_NAME"                = ""
    "DB_USER"                = ""
    "DB_PASS"                = ""
    "DB_URL"                 = "mongodb+srv://justin:osk7mvsXG0xDgBAS@luxe-staging.vzeoad0.mongodb.net/casino_stag"
    "AWS_ACCESS_KEY_ID"      = "AKIAS6KORSRP74HLKLIG"
    "AWS_SECRET_ACESS_KEY"   = "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"
    "AWS_REGION"             = "ap-southeast-2"
    "S3_BUCKET_NAME"         = "backend-resource-staging"
    "CLOUDFRONT_URL"         = "https://assets-staging.theluxelottery.com"
    "UPLOAD_TO_S3_BUCKET"    = "true"
    "NODEMAILER_HOST"        = "smtp-relay.sendinblue.com"
    "NODEMAILER_USER"        = "prateekjain.091@gmail.com"
    "NODEMAILER_PASSWORD"    = "2MnsVhFxSEzjAwLR"
    "SENDER_NAME"            = "Prateek"
    "SENDER_EMAIL"           = "luxcasino@gmail.com"
    "NODEMAILER_PORT"        = "587"
    "GIVE2KIDS_SENDER_NAME"  = "GiveToTheKids"
    "GIVE2KIDS_SENDER_EMAIL" = "hello@minihearts.org"
    "SUPER_ADMIN_EMAIL"      = "superadmin@yopmail.com"
    "SUPER_ADMIN_PASS"       = "@Pk12345"
    "SUPER_ADMIN_NAME"       = "Colin"
    "SUPER_ADMIN_FIRST_NAME" = "Super"
    "SUPER_ADMIN_LAST_NAME"  = "Admin"
    "SWAGGER_AUTH_USERNAME"  = "chicmic"
    "SWAGGER_AUTH_PASSWORD"  = "chicmic"
    "API_AUTH_KEY"           = "7HLsBfaH6b2YR7nw"
    "REDIS_PORT"             = ""
    "REDIS_HOST"             = ""
    "REDIS_PASSWORD"         = ""
    "PINO_API_KEY"           = "SIkke2o97VSS"
    "PINO_API_SECRET"        = "81e8c3a2-a9d3-4d7b-b2a1-2fe6e164353b"
    "WEB_URL"                = "https://web-staging.theluxelottery.com"
    "ADMIN_WEB_URL"          = "https://admin-staging.theluxelottery.com"

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
  git_username        = "Colin-Mackenzie-Slots"
  git_repo            = "Luxe_Lotteries_Socket_NodeJs"
  git_token           = "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"
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
    "SERVER_HOST"            = "0.0.0.0"
    "SERVER_SOCKET_PORT"     = "8080"
    "SERVER_PROTOCOL"        = "http"
    "USER_DEFAULT_PASSWORD"  = "@UserPassword@1"
    "DB_PROTOCOL"            = "mongodb"
    "DB_HOST"                = "127.0.0.1"
    "DB_PORT"                = "27017"
    "DB_NAME"                = ""
    "DB_USER"                = ""
    "DB_PASS"                = ""
    "DB_URL"                 = "mongodb+srv://justin:osk7mvsXG0xDgBAS@luxe-staging.vzeoad0.mongodb.net/casino_stag"
    "AWS_ACCESS_KEY_ID"      = "AKIAS6KORSRP74HLKLIG"
    "AWS_SECRET_ACESS_KEY"   = "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"
    "AWS_REGION"             = "ap-southeast-2"
    "S3_BUCKET_NAME"         = "backend-resource-staging"
    "CLOUDFRONT_URL"         = "https://assets-staging.theluxelottery.com"
    "UPLOAD_TO_S3_BUCKET"    = "true"
    "NODEMAILER_HOST"        = "smtp-relay.sendinblue.com"
    "NODEMAILER_USER"        = "prateekjain.091@gmail.com"
    "NODEMAILER_PASSWORD"    = "2MnsVhFxSEzjAwLR"
    "SENDER_NAME"            = "Prateek"
    "SENDER_EMAIL"           = "luxcasino@gmail.com"
    "NODEMAILER_PORT"        = "587"
    "SUPER_ADMIN_EMAIL"      = "superadmin@yopmail.com"
    "SUPER_ADMIN_PASS"       = "@Pk12345"
    "SUPER_ADMIN_NAME"       = "Colin"
    "SUPER_ADMIN_FIRST_NAME" = "Super"
    "SUPER_ADMIN_LAST_NAME"  = "Admin"
    "SWAGGER_AUTH_USERNAME"  = "chicmic"
    "SWAGGER_AUTH_PASSWORD"  = "chicmic"
    "API_AUTH_KEY"           = "7HLsBfaH6b2YR7nw"
    "REDIS_PORT"             = ""
    "REDIS_HOST"             = ""
    "REDIS_PASSWORD"         = ""
    "PINO_API_KEY"           = "SIkke2o97VSS"
    "PINO_API_SECRET"        = "81e8c3a2-a9d3-4d7b-b2a1-2fe6e164353b"
    "WEB_URL"                = "https://web-staging.theluxelottery.com"
    "ADMIN_WEB_URL"          = "https://admin-staging.theluxelottery.com"

  }
  minsize = 1
  maxsize = 2
}

