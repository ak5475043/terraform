output "domain" {
  description = "Elasticbeanstalk domain name"
  value = aws_elastic_beanstalk_environment.sample_env.cname
}
