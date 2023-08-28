resource "aws_eip" "this" {
  domain = "vpc"

  tags = {
    Name = "custom_eip"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public_subnets[0].id  # Assuming you have a list of public_subnets

  tags = {
    Name = "custom_NAT"
  }

  depends_on = [aws_internet_gateway.gw]
}