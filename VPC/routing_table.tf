resource "aws_route_table" "second_rt" {

  vpc_id = aws_vpc.main.id



  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.gw.id

  }



  tags = {

    Name = "2nd Route Table"

  }

}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
  
  tags = {
    Name = "private route table"
  }
}





# resource "aws_default_route_table" "example" {
#    default_route_table_id = aws_vpc.main.default_route_table_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

# #   route {
# #     ipv6_cidr_block        = "::/0"
# #     egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
# #   }

#   tags = {
#     Name = "example"
#   }
# }