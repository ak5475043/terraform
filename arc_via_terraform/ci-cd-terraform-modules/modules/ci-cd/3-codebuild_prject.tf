# resource "aws_codebuild_project" "example" {
#   name         = "example-codebuild-project"
#   description  = "Example CodeBuild Project"
#   service_role = aws_iam_role.codebuild_role.arn
#   artifacts {
#     type = "CODEPIPELINE"
#   }
#   cache {
#     type     = "S3"
#     location = aws_s3_bucket.mybucket.bucket
#   }

#   environment {
#     compute_type = "BUILD_GENERAL1_SMALL"
#     image        = "aws/codebuild/standard:5.0"
#     type         = "LINUX_CONTAINER"
#   }
#   source {
#     type      = "CODEPIPELINE"
#     buildspec = file("${path.module}/buildspec.yml")
#   }
# }