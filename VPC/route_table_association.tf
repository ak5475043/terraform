resource "aws_route_table_association" "public_subnet_asso" {

  count = length(var.public_subnet_cidrs)

  subnet_id = element(aws_subnet.public_subnets[*].id, count.index)

  route_table_id = aws_route_table.second_rt.id

}

resource "aws_route_table_association" "private_subnet_asso" {

  count = length(var.private_subnet_cidrs)

  subnet_id = element(aws_subnet.private_subnets[*].id, count.index)

  route_table_id = aws_route_table.private.id

}