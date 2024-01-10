
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "private_subnet_az1" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_subnet_az1_cidr
    availability_zone = var.az1
    tags = {
        Name = "${var.vpc_name}-private_subnet_az1"
    }
}

resource "aws_subnet" "private_subnet_az2" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_subnet_az2_cidr
    availability_zone = var.az2
    tags = {
        Name = "${var.vpc_name}-private_subnet_az2"
    }
}
