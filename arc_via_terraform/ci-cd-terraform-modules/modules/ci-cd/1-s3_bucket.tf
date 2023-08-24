resource "aws_s3_bucket" "mybucket" {
  bucket = var.s3_bucket_name
  versioning {
    enabled = true
  }
}