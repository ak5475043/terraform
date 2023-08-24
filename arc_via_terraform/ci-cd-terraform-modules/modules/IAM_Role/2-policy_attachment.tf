# resource "aws_iam_role_policy_attachment" "codebuild_s3_policy_attachment" {
#   role       = aws_iam_role.codebuild_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
# }
# resource "aws_iam_role_policy_attachment" "codebuild_s3_fullaccess_attachment" {
#   role       = aws_iam_role.codebuild_role.name
#   policy_arn = aws_iam_policy.s3_write_only_access.arn
# }
# resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
#   role       = aws_iam_role.codebuild_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
# }
# resource "aws_iam_role_policy_attachment" "codebuild_logs_policy_attachment" {
#   role       = aws_iam_role.codebuild_role.name
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
# }

resource "aws_iam_policy_attachment" "s3_policy_attachment" {
  name       = "example-codepipeline-role-attachment"
  roles      = [aws_iam_role.codepipeline_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_role_policy_attachment" "code_policy_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
}
resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalk_policy_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk"
}
resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.AWSCodePipeline_FullAccess.arn
}
