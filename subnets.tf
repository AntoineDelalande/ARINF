resource "aws_subnet" "AZC" {
  vpc_id            = aws_vpc.ARINF_project_vpc.id
  availability_zone = "eu-west-3c"
  cidr_block        = "10.0.3.0/24"
}

resource "aws_subnet" "AZB" {
  vpc_id            = aws_vpc.ARINF_project_vpc.id
  availability_zone = "eu-west-3b"
  cidr_block        = "10.0.2.0/24"
}

resource "aws_subnet" "AZA" {
  vpc_id            = aws_vpc.ARINF_project_vpc.id
  availability_zone = "eu-west-3a"
  cidr_block        = "10.0.1.0/24"
}