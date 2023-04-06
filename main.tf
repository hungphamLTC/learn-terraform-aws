# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_cidr)

  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr[count.index]

  tags = {
    Name = "${var.area_code}-public${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_cidr)

  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr[count.index]

  tags = {
    Name = "${var.area_code}-private${count.index}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# create Elastic Ip address for NAT
resource "aws_eip" "nat" {
  count = 2

  vpc = true

  tags = {
    Name = "${var.area_code}-nat${count.index}"
  }
}

resource "aws_nat_gateway" "public" {
  count = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.area_code}-public${count.index}"
  }

}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "public_route"
  }
}

resource "aws_route_table" "private" {
  count = 2

  vpc_id = aws_vpc.main.id

  route {
    # why we use 0.0.0.0/0, not 10.0.3.0? 
    # Does it mean all the host in private subnet can go to either public0 or public1 if one of those are down?
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public[count.index].id
  }
  tags = {
    Name = "${var.area_code}-private${count.index}"
  }
}


resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = 2

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
