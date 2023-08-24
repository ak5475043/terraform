resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  #public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCdcKzkb8e5XBR2+QavP95czhl54lyNW/Z/ufTUyGqXqAywXHcuggs8ai85ax1i6DUgcF31NsfjwR36ZDTnolldw2AcPrUL79HzvDiCUQnWw44EdzRnI78uzI7mKZLv6soIzQgxMetybFVQENqwBLE7DaL4mzkpcd6bCTAHnQIZfNNXy6KIGzDbpLF8bbVmAqsztbpW1gCwB7hTpnCVZCwySFzNI+sBjSvGcCzFBnhH6aNx2SI41tcbB3PApEdM/x918dN944m1lzMc3BPhyngTvJINqIq7hTcXlhaCiH1hn0Bs8eJFoTqa/Yh8EGMI5f0Y1TUzeQSjx4ghXaErXAmbLMczXP2lOQ3CegZ6yvpxb+CcnmcV4H9Ew7RVMQqK0Beh/ZSPoL5KIqBWbCd7oEU7mSpKnXVKAlwTVy0izUJ+uCTfxjgLWaeSksMuA1XP9vpHpUOA3u9BwZpFCLwb3SFmNKOv/4FEVfJDM1mWc2LntbNlrNR4blY64XOpUyImRys= ak@chicmic-H510M-H"
  public_key = file("${path.module}/id_rsa.pub")
}

# output keyname {
#     value = aws_key_pair.deployer.key_name
# }




resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}



# output security_id {
#     value = aws_security_group.allow_tls.id
# }



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

# output "ami_id" {
#   value = data.aws_ami.ubuntu.id
# }




resource "aws_instance" "web"{
  #ami             = "ami-053b0d53c279acc90"
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  tags = {
    Name = "first-tf-instance"
  }
  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install nginx -y
sudo echo "hii ayush" >/var/www/html/index.nginx-debian.html
EOF 


  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("${path.module}/id_rsa")
    host = "${self.public_ip}"
  }
  
  provisioner "file" {
    source = "readme.md"
    destination = "/tmp/readme.md"
  }

  provisioner "file" {
    content = "this is test content"
    destination = "/tmp/content.md"
  }

  provisioner "file" {
    source = "test_folder"
    destination = "/tmp/dest_test_folder"
  }  

  provisioner "local-exec" {
    working_dir = "/tmp/"
    command = "echo ${self.public_ip} > mypublicip.txt"
  }  

  provisioner "local-exec" {
    interpreter = [
      "/usr/bin/python3", "-c"
      ]
    command = "print('Hello_World')"
  }  

  provisioner "local-exec" {
    #on_failure = continue
    command = "env>env.txt"
    environment = {
      envname = "envvalue"
    }
  }  

  provisioner "local-exec" {
    command = "echo 'at-create'"
  }

  provisioner "local-exec" {
    when = destroy
    command = "echo 'at-delete'"
  }    
  
  provisioner "remote-exec" {
    inline = [
      "ifconfig > /tmp/ifconfig.output",
      "echo 'hello ayush' > /tmp/testt.txt"
    ]
  }

  provisioner "remote-exec" {
    script = "./tsetscript.sh"
  }
}