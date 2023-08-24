resource "aws_codepipeline" "example" {
  name     = "pipeline-${var.app_name}"
  role_arn = var.iam_role_arn

  artifact_store {
    location = aws_s3_bucket.mybucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.git_username
        Repo       = var.git_repo
        Branch     = var.repo_branch
        OAuthToken = var.git_token
        
      }
    }
  }

#  stage {
#    name = "Build"
#
#    action {
#      name             = "BuildAction"
#      category         = "Build"
#      owner            = "AWS"
#      provider         = "CodeBuild"
#      input_artifacts  = ["source_output"]
#      output_artifacts = ["build_output"]
#      version          = "1"
#      configuration = {
#        ProjectName = aws_codebuild_project.example.name
#      }
#    }
#  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployAction"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      input_artifacts = ["source_output"]
      version         = "1"
      configuration = {
        ApplicationName = aws_elastic_beanstalk_application.sample_app.name
        EnvironmentName = aws_elastic_beanstalk_environment.sample_env.name
      }
    }
  }
}
