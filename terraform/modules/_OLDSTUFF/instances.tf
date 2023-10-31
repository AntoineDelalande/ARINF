resource "aws_instance" "replica_C" {
  ami           = var.AWS_AMIS["default"]
  instance_type = "t2.micro"
  //subnet_id     = aws_subnet.AZC.id

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

//  user_data = <<-EOF
		//#!/bin/bash
    //sudo apt-get update
		//sudo apt-get install -y apache2
		//sudo systemctl start apache2
		//sudo systemctl enable apache2
		//sudo echo "<h1>Hello devopssec</h1>" > /var/www/html/index.html
	//EOF

  tags = {
    Name = "replica_C"
  }
}
resource "aws_instance" "replica_B" {
  ami           = var.AWS_AMIS["default"]
  instance_type = "t2.micro"
  //subnet_id     = aws_subnet.AZB.id

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

//  user_data = <<-EOF
		//#!/bin/bash
        //sudo apt-get update
		//sudo apt-get install -y apache2
		//sudo systemctl start apache2
		//sudo systemctl enable apache2
		//sudo echo "<h1>Hello devopssec</h1>" > /var/www/html/index.html
	//EOF

  tags = {
    Name = "replica_B"
  }
}

resource "aws_instance" "replica_A" {
  ami           = var.AWS_AMIS["default"]
  instance_type = "t2.micro"
  //subnet_id     = aws_subnet.AZA.id

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

//  user_data = <<-EOF
		//#!/bin/bash
        //sudo apt-get update
		//sudo apt-get install -y apache2
		//sudo systemctl start apache2
		//sudo systemctl enable apache2
		//sudo echo "<h1>Hello devopssec</h1>" > /var/www/html/index.html
	//EOF

  tags = {
    Name = "replica_A"
  }
}