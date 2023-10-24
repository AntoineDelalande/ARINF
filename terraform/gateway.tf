resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ARINF_project_vpc.id

  tags = {
    Name = "igw"
  }

}