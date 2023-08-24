terraform {
    backend "s3" {
        bucket = "tf.back"
        region = "us-east-1"
        key = "terraform.tfstate"
    }
}


provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAXJOH6M7ZPDW6PY3T"
  secret_key = "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"

}


resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = file("${path.module}/id_rsa.pub")
}  


resource "aws_instance" "web"{
  ami             = "ami-053b0d53c279acc90"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.deployer.key_name
  tags = {
    Name = "first-tf-instance"
  }
}