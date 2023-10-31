resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr 

  tags = {
    name = "ARINF_main_vpc"
  }
}

resource "aws_subnet" "main_sb" {
  count = length(var.subnets_cidr)
  
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = var.azs[count.index]
  cidr_block = var.subnets_cidr[count.index]

  tags = {
    name = "ARINF_subnet_AZ${count.index}"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "ARINF_main_igw"
  }

}

resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "ARINF_main_rt"
  }
}

resource "aws_route_table_association" "main-public" {
  count = length(var.subnets_cidr)
  subnet_id = aws_subnet.main_sb[count.index].id
  route_table_id = aws_route_table.main_rt.id
}