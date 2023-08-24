provider "aws" {
    region = "us-east-1"
}
terraform {
    backend "local"{
        path = "modules/terraform.tfstate"
    }
}

module "ci-cd" {
    source = "../modules/ci-cd"
    access_key = "AKIAQBewwweMF6Q5K43"
    secret_key = "XZ/NtD8eweQcNGDFoNlcsXu9X3h71AXgd4lX"
    git_username = "singhragvendra503"
    git_repo = "nodejs-app"
    git_token = "ghp_J8cSNZVVHwewljxTixMTJ9WE20z4JYk"
    repo_branch = "main"
    env = "dev"
    aws_region = "us-east-1"
    s3_bucket_name = "demmo503"
    solution_stack_name = "64bit Amazon Linux 2 v5.8.2 running Node.js 14"
    application_tier = "WebServer"
    instance_type = "t2.micro"
    environment_type = "LoadBalanced"
    environment_variables = {
    "DB_HOST" = "loachost"
    "DB_NAME" = "database"
    "DB_USERNAME" = "root"
    "DB_PASSWORD" ="root123"
    }
    minsize = 1
    maxsize = 2
}