
# Create a new Elastic Beanstalk application
resource "aws_elastic_beanstalk_application" "sample_app" {
  name        = "${var.env}-${var.app_name}"         # Update with your desired application name
  description = "Sample application" # Update with your desired application description
}

# Create a new Elastic Beanstalk environment
resource "aws_elastic_beanstalk_environment" "sample_env" {
  name                = "${var.env}-${var.app_name}-env" # Update with your desired environment name
  application         = aws_elastic_beanstalk_application.sample_app.name
  tier                = var.application_tier
  solution_stack_name = var.solution_stack_name # Update with your desired solution stack
  #depends_on = [module.vpc]
  # Configure vpc
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }
  # Configure public subnet
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.private_subnet_ids)
  }
  

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", var.public_subnet_ids)  # Replace with your ELB subnet IDs (comma-separated)
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.minsize
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.maxsize
  }
  # Configure environment properties
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type # Update with your desired instance type
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = var.environment_type # Update with "LoadBalanced" if you want a load-balanced environment
  }

  # Configure environment variables
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "APP_ENV"
    value     = "production" # Update with your desired environment variable
  }
    # Use a map to store your environment variables
  dynamic "setting" {
    for_each = var.environment_variables

    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
    }
  }

  # Create a new S3 bucket for storing application versions
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentBucketName"
    value     = aws_s3_bucket.mybucket.bucket # Update with your desired S3 bucket name
  }

  # Create a new IAM instance profile for EC2 instances
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role" # Update with your desired IAM instance profile
  }
  
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "LoadBalancerType"
    value = var.load_balancer_type
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "CPUUtilization"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Statistic"
    value     = "Average"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = "Percent"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = "60" # Adjust this value as needed
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = "30" # Adjust this value as needed
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "BreachDuration"
    value     = "2"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = var.key_pair_name
  }
}
