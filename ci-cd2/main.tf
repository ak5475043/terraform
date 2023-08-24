# Create an IAM role for CodePipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-role"
  assume_role_policy = <<EOF
 {
   "Version": "2012-10-17",
   "Statement": [
     {
       "Sid": "",
       "Effect": "Allow",
       "Principal": {
         "Service": ["codepipeline.amazonaws.com", "codebuild.amazonaws.com", "elasticbeanstalk.amazonaws.com"]
       },
       "Action": "sts:AssumeRole"
     }
   ]
 }
EOF
}


resource "aws_iam_policy" "codebuild_cloudwatch_logs_policy" {
  name        = "codebuild-cloudwatch-logs-policy"
  description = "IAM policy for AWS CodeBuild to access CloudWatch Logs"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild_cloudwatch_logs_policy_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codebuild_cloudwatch_logs_policy.arn
}




# Create a custom IAM policy for CodePipeline
resource "aws_iam_policy" "codepipeline_policy" {
  name        = "codepipeline-policy"
  description = "Custom IAM policy for CodePipeline"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codepipeline:*",
        "iam:PassRole",
        "s3:Get*",
        "s3:List*",
        "elasticbeanstalk:*",
        "codebuild:StartBuild",
        "codebuild:BatchGetBuilds"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach the custom policy to the CodePipeline IAM role
resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}


# Create the CodePipeline artifact bucket
resource "aws_s3_bucket" "codepipeline_artifact_bucket" {
  bucket = "my-codepipeline-artifact-bucket-21"  # Update with your desired bucket name
}


resource "aws_iam_role_policy" "codepipeline_s3_policy" {
  name   = "codepipeline-s3-policy"
  role   = aws_iam_role.codepipeline_role.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CodePipelineS3Access",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::my-codepipeline-artifact-bucket-21/*",
        "arn:aws:s3:::my-codepipeline-artifact-bucket-21"
      ]
    }
  ]
}
EOF
}



# Create the CodePipeline pipeline
resource "aws_codepipeline" "my_codepipeline" {
  name     = "my-codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_artifact_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner              = "ak5475043"
        Repo               = "react-eb"
        Branch             = "master"  # Update with your desired branch
        OAuthToken         = "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"
        PollForSourceChanges = "false"
      }
    }
  }

    stage {
    name = "Build"

    action {
      name            = "BuildAction"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = "my-codebuild-project"  # Update with your desired CodeBuild project name
      }
    }
  }


    stage {
    name = "Deploy"

    action {
      name            = "DeployAction"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
      ApplicationName = "my-eb-application"  # Update with your desired Elastic Beanstalk application name
      EnvironmentName = "my-eb-environment"  # Update with your desired Elastic Beanstalk environment name
    }
  }
}


  #   stage {
  #   name = "Deploy"

  #   action {
  #     name            = "DeployAction"
  #     category        = "Deploy"
  #     owner           = "AWS"
  #     provider        = "S3"
  #     version         = "1"
  #     input_artifacts = ["build_output"]

  #     configuration = {
  #       BucketName      = "my-codepipeline-artifact-bucket-21"  # Update with your S3 bucket name
  #       Extract         = "true"
  #       #ObjectKey       = "artifacts/*"
  #     }
  #   }
  # }
}

# Create a CodeBuild project
resource "aws_codebuild_project" "my_codebuild_project" {
  name       = "my-codebuild-project"
  description = "CodeBuild project for building and packaging the application"
  service_role = aws_iam_role.codepipeline_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "us-east-1"  # Update with your desired region
    }
  }
  source {
    type = "CODEPIPELINE"
    buildspec = file("${path.module}/buildspec.yml")
  }

  logs_config {
    cloudwatch_logs {
      status  = "ENABLED"
      group_name = "/aws/codebuild/codebuild"  # Update with your desired CloudWatch Log Group name
    }
  }


  tags = {
    Name = "my-codebuild-project"
  }
}



# Create the Elastic Beanstalk application
resource "aws_elastic_beanstalk_application" "my_eb_application" {
  name        = "my-eb-application"  # Update with your desired application name
  description = "Elastic Beanstalk application"
}


# Create the Elastic Beanstalk environment
resource "aws_elastic_beanstalk_environment" "my_eb_environment" {
  name                = "my-eb-environment"  # Update with your desired environment name
  application         = aws_elastic_beanstalk_application.my_eb_application.name
  solution_stack_name = "64bit Amazon Linux 2 v5.8.3 running Node.js 14"
  #version_label       = aws_codepipeline.my_codepipeline.stage[1].action[0].configuration["OutputArtifacts"][0]["Name"]
  wait_for_ready_timeout = "10m"

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.codepipeline_role.arn
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro" # Update with your desired instance type
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role" # Update with your desired IAM instance profile
  }
}


resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalk_policy_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk"
}

