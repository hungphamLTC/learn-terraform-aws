# Creating EC2 instance in public Subnet

resource "aws_instance" "public" {
  ami                         = var.ami_id
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.public.id]
  subnet_id                   = aws_subnet.public[0].id

  tags = {
    Name = "${var.area_code}-public"
  }
}

resource "aws_security_group" "public" {
  name        = "${var.area_code}-public"
  description = "Security Group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["91.158.228.182/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.area_code}-public"
  }
}

resource "aws_instance" "private" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.private.id]
  subnet_id              = aws_subnet.private[0].id

  tags = {
    Name = "${var.area_code}-private"
  }
}

resource "aws_security_group" "private" {
  name        = "${var.area_code}-private"
  description = "Security Group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.area_code}-private"
  }
}
