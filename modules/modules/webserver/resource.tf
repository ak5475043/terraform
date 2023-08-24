resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
    public_key = var.key
}




resource "aws_instance" "web" {
    ami = var.image_id
    instance_type = var.instance_type
    key_name = aws_key_pair.deployer.key_name
}


