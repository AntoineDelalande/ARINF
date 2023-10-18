terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-3"
}

resource "aws_vpc" "ARINF_project_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "AZC" {
  vpc_id = aws_vpc.ARINF_project_vpc.id
  availability_zone = "eu-west-3c"
  cidr_block = "10.0.3.0/24"
}

resource "aws_subnet" "AZB" {
  vpc_id = aws_vpc.ARINF_project_vpc.id
  availability_zone = "eu-west-3b"
  cidr_block = "10.0.2.0/24"
}

resource "aws_subnet" "AZA" {
  vpc_id = aws_vpc.ARINF_project_vpc.id
  availability_zone = "eu-west-3a"
  cidr_block = "10.0.1.0/24"
}


resource "aws_instance" "replica_C" {
  ami = "ami-0ebc281c20e89ba4b"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.AZC.id

  tags = {
    Name = "replica_C"
  }
}
resource "aws_instance" "replica_B" {
  ami = "ami-0ebc281c20e89ba4b"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.AZB.id

  tags = {
    Name = "replica_B"
  }
}

resource "aws_instance" "replica_A" {
  ami = "ami-0ebc281c20e89ba4b"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.AZA.id

  tags = {
    Name = "replica_A"
  }
}