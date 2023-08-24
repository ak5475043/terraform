resource "aws_iam_policy" "AWSCodePipeline_FullAccess" {
  name        = "AWSCodePipeline_FullAccess"
  path        = "/"
  description = "My test policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "codepipeline:*",
            "Resource": "*"
        }
    ]
})
}

resource "aws_iam_policy" "s3_write_only_access" {
  name        = "s3_write_only_access"
  path        = "/"
  description = "My test policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "*"
        }
    ]
})
}