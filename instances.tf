resource "aws_instance" "replica_C" {
  ami           = "ami-0ebc281c20e89ba4b"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.AZC.id

  tags = {
    Name = "replica_C"
  }
}
resource "aws_instance" "replica_B" {
  ami           = "ami-0ebc281c20e89ba4b"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.AZB.id

  tags = {
    Name = "replica_B"
  }
}

resource "aws_instance" "replica_A" {
  ami           = "ami-0ebc281c20e89ba4b"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.AZA.id

  tags = {
    Name = "replica_A"
  }
}