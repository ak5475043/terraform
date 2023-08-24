resource "aws_s3_bucket" "example_bucket" {
  bucket = "gfuk"
  acl    = "private"

  versioning {
    enabled = true
  }

  # block_public_acl       = false
  # block_public_policy     = false
  # ignore_public_acl      = false
  # restrict_public_buckets = false

  tags = {
    Name        = "Example Bucket"
    Environment = "Production"
  }
}

# output s3_name {
#     value = aws_s3_bucket.example_bucket.id
# }

# output s3_arn {
#     value = aws_s3_bucket.example_bucket.arn
# }

# output s3_domain_name {
#     value = aws_s3_bucket.example_bucket.bucket_domain_name
# }

# output s3_region {
#     value = aws_s3_bucket.example_bucket.region
# }




resource "aws_s3_bucket_object" "object" {
  bucket = "gfuk"
  key    = "index.jpg"
  source = "/home/ak/terraform/s3/index.jpg"
  content_type = "image/jpg"

  # Grant public read access to the object
  #acl = "public-read"
}



resource "aws_s3_bucket_object" "object1" {
  bucket = "gfuk"
  key    = "index.html"
  source = "/home/ak/terraform/s3/index.html"
  content_type = "text/html"
  
  # Grant public read access to the object
  #acl = "public-read"
}


# Create CloudFront origin access control
resource "aws_cloudfront_origin_access_control" "demo_origin_access_control" {
  name                            = "${aws_s3_bucket.example_bucket.id}.s3.us-east-1.amazonaws.com"
  origin_access_control_origin_type = "s3"
  signing_behavior                = "no-override"
  signing_protocol                = "sigv4"
}


# Create CloudFront distribution
resource "aws_cloudfront_distribution" "demo_distribution" {
  origin {
    domain_name              = aws_s3_bucket.example_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.demo_origin_access_control.id
    origin_id                = "${aws_s3_bucket.example_bucket.id}.s3.us-east-1.amazonaws.com"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.jpg"
# default cache behavior
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_s3_bucket.example_bucket.id}.s3.us-east-1.amazonaws.com"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress = true
  }

 
  price_class = "PriceClass_200"

    restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  #Custom error response for single page applications
  custom_error_response {
    error_code      = 403
    response_code   = 200
    response_page_path = "/index.html"
  }
  custom_error_response {
    error_code      = 404
    response_code   = 200
    response_page_path = "/index.html"
  }
}


# Grant read permission to the CloudFront origin access identity
resource "aws_s3_bucket_policy" "demo_website_bucket_policy" {
  bucket = aws_s3_bucket.example_bucket.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipalReadOnly",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.example_bucket.id}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::5013-1988-6834:distribution/${aws_cloudfront_distribution.demo_distribution.id}"
                }
            }
        }
    ]
}
EOF
}


output DNS {
  value = aws_cloudfront_distribution.demo_distribution.domain_name
}


