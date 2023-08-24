# Create VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"  # Update this to an appropriate AZ
}

# Create private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"  # Update this to an appropriate AZ
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id
}

#Update VPC's main route table for Internet access
resource "aws_route" "public_route2" {
  route_table_id         = aws_vpc.custom_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet.id
}

# Allocate Elastic IP for NAT Gateway
resource "aws_eip" "nat" {}

# Update public subnet's route table for Internet access
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.custom_vpc.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Update private subnet's route table for NAT Gateway access
resource "aws_route_table_association" "private_route_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.custom_vpc.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Create Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "my_app" {
  name = "my-beanstalk-app"
}

# Create Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "my_env" {
  name                = "my-env"
  application         = aws_elastic_beanstalk_application.my_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.8.3 running Node.js 14"  # Update this to your desired stack
  cname_prefix        = "my-env"
  tier                = "WebServer"
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"  # Update this to your desired instance type
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = aws_subnet.private_subnet.id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = aws_subnet.public_subnet.id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role" # Update with your desired IAM instance profile
  }
#   setting {
#     namespace = "aws:elasticbeanstalk:environment"
#     name      = "LoadBalancerType"
#     value     = "application"  # Load balancer type (application or classic)
#   }
  
#   setting {
#     namespace = "aws:elasticbeanstalk:environment"
#     name      = "LoadBalancerHTTPPort"
#     value     = "80"  # Update with the desired port
#   }
  
#   setting {
#     namespace = "aws:elasticbeanstalk:environment"
#     name      = "LoadBalancerSecurityGroups"
#     value     = aws_security_group.lb_sg.id
#   }
}

# Configure Security Groups and other resources as needed


# Create Load Balancer
# resource "aws_lb" "my_load_balancer" {
#   name               = "my-load-balancer"
#   internal           = false
#   load_balancer_type = "application"
#   subnets            = [aws_subnet.public_subnet.id]  # Use the public subnet for the load balancer
# }


# # Configure Security Group for Load Balancer
# resource "aws_security_group" "lb_sg" {
#   name        = "lb-security-group"
#   description = "Security group for load balancer"
  
#   # Define inbound and outbound rules as needed
# }

# # Update Elastic Beanstalk Environment to Use Load Balancer
# resource "aws_elastic_beanstalk_environment" "my_env" {
#   # ... (other settings)
  
#   setting {
#     namespace = "aws:elasticbeanstalk:environment"
#     name      = "LoadBalancerType"
#     value     = "application"  # Load balancer type (application or classic)
#   }
  
#   setting {
#     namespace = "aws:elasticbeanstalk:environment"
#     name      = "LoadBalancerHTTPPort"
#     value     = "80"  # Update with the desired port
#   }
  
#   setting {
#     namespace = "aws:elasticbeanstalk:environment"
#     name      = "LoadBalancerSecurityGroups"
#     value     = aws_security_group.lb_sg.id
#   }
  
#   # ... (other settings)
# }

# Configure Load Balancer Listeners and Target Groups
# resource "aws_lb_listener" "my_listener" {
#   load_balancer_arn = aws_lb.my_load_balancer.arn
#   port              = 80
#   protocol          = "HTTP"
  
#   default_action {
#     target_group_arn = aws_lb_target_group.my_target_group.arn
#     type             = "fixed-response"
    
#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Hello from the load balancer!"
#       status_code  = "200"
#     }
#   }
# }

# resource "aws_lb_target_group" "my_target_group" {
#   name     = "my-target-group"
#   port     = 80
#   protocol = "HTTP"
  
#   health_check {
#     interval            = 30
#     path                = "/"
#     port                = "80"
#     protocol            = "HTTP"
#     unhealthy_threshold = 2
#     healthy_threshold   = 2
#   }
# }

# ... (Other resources and configurations)