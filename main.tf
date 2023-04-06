# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.area_code
  }
}

resource "aws_subnet" "public0" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr[0]

  tags = {
    Name = "${var.area_code}-public0"
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr[1]

  tags = {
    Name = "${var.area_code}-public1"
  }
}

resource "aws_subnet" "private0" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr[0]

  tags = {
    Name = "${var.area_code}-private0"
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr[1]

  tags = {
    Name = "${var.area_code}-private1"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.area_code
  }
}

# create Elastic Ip address for NAT
resource "aws_eip" "nat0" {
  vpc      = true
  tags = {
    Name = "${var.area_code}-nat0"
  }
}

# create Elastic Ipaddress for NAT
resource "aws_eip" "nat1" {
  vpc      = true
  tags = {
    Name = "${var.area_code}-nat1"
  }
}

resource "aws_nat_gateway" "public0" {
  allocation_id = aws_eip.nat0.id
  subnet_id     = aws_subnet.public0.id

  tags = {
    Name = "${var.area_code}-public0"
  }

}

resource "aws_nat_gateway" "public1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "${var.area_code}-public1"
  }

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.area_code}-public"
  }
}

resource "aws_route_table" "private0" {
  vpc_id = aws_vpc.main.id

  route {
      # why we use 0.0.0.0/0, not 10.0.3.0? 
      # Does it mean all the host in private subnet can go to either public0 or public1 if one of those are down?
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public0.id
  }
  tags = {
    Name = "${var.area_code}-private0"
  }
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id

  route {
    # why we use 0.0.0.0/0, not 10.0.3.0? 
    # Does it mean all the host in private subnet can go to either public0 or public1 if one of those are down?
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public1.id
<<<<<<< HEAD
=======

>>>>>>> 0342d6c (Using variable and setting their values)
  }
  tags = {
    Name = "${var.area_code}-private1"
  }
}

resource "aws_route_table_association" "public0" {
  subnet_id      = aws_subnet.public0.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private0" {
  subnet_id      = aws_subnet.private0.id
  route_table_id = aws_route_table.private0.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}
