resource "aws_lb" "main_alb" {
  name = "main_alb"
  internal = false
  load_balancer_type = "application"
  subnets = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    name = "ARINF_main_lb"
  }
}

resource "aws_security_group" "instance_sg" {
  name = "terraform-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}