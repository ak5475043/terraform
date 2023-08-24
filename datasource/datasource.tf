provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAXJOH6M7ZPDW6PY3T"
  secret_key = "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"

}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "ami_id" {
  value = data.aws_ami.ubuntu.id
}