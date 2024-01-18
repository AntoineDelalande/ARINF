resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr 
  instance_tenancy = "default"

  tags = {
    Name = "ARINF_main_vpc"
  }
}

resource "aws_subnet" "main_sb" {
  count = length(var.subnets_cidr)
  
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = var.azs[count.index]
  cidr_block = var.subnets_cidr[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "ARINF_subnet_AZ${count.index}"
  }
}

resource "aws_security_group" "main_sg" {
  name = "ARINF_main_sg"
  vpc_id = aws_vpc.main_vpc.id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 2379
    to_port = 2379
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ARINF_main_sg"
    description = "Allow SSH, HTTP, HTTPS, K8S API"
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

resource "aws_route_table_association" "main_rt_association" {
  count = length(var.subnets_cidr)
  subnet_id = aws_subnet.main_sb[count.index].id
  route_table_id = aws_route_table.main_rt.id
}

//resource "aws_instance" "replica" {
  //count = length(var.subnets_cidr)
  //ami = var.AWS_AMIS["default"]
  //instance_type = "t2.micro"
  //subnet_id = aws_subnet.main_sb[count.index].id

  //vpc_security_group_ids = [aws_security_group.main_sg.id]

  //#key_name = ""

    ////user_data = <<-EOF
		////#!/bin/bash
        ////sudo apt-get update
		////sudo apt-get install -y apache2
		////sudo systemctl start apache2
		////sudo systemctl enable apache2
		////sudo echo "<h1>Hello devopssec</h1>" > /var/www/html/index.html
	  ////EOF
  //tags = {
    //Name = "ARINF_replica_${count.index}"
  //}
//}