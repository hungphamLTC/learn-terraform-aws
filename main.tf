# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "public0" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public0"
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "public1"
  }
}

resource "aws_subnet" "private0" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "private0"
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "private1"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# create Elastic Ipaddress for NAT
resource "aws_eip" "nat0" {
  vpc      = true
  tags = {
    Name = "nat0"
  }
}

# create Elastic Ipaddress for NAT
resource "aws_eip" "nat1" {
  vpc      = true
  tags = {
    Name = "nat1"
  }
}

resource "aws_nat_gateway" "public0" {
  allocation_id = aws_eip.nat0.id
  subnet_id     = aws_subnet.public0.id

  tags = {
    Name = "public0"
  }

}

resource "aws_nat_gateway" "public1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "public1"
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

resource "aws_route_table" "private_route0" {
  vpc_id = aws_vpc.main.id

  route {
      # why we use 0.0.0.0/0, not 10.0.3.0? 
      # Does it mean all the host in private subnet can go to either public0 or public1 if one of those are down?
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.public0.id
  }
  tags = {
    Name = "private_route0"
  }
}

resource "aws_route_table" "private_route1" {
  vpc_id = aws_vpc.main.id

  route {
    # why we use 0.0.0.0/0, not 10.0.3.0? 
    # Does it mean all the host in private subnet can go to either public0 or public1 if one of those are down?
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.public1.id
  }
  tags = {
    Name = "private_route1"
  }
}

resource "aws_route_table_association" "public0" {
  subnet_id      = aws_subnet.public0.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private0" {
  subnet_id      = aws_subnet.private0.id
  route_table_id = aws_route_table.private_route0.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_route1.id
}