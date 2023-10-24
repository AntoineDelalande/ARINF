resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.AZA.id, aws_subnet.AZB.id, aws_subnet.AZC.id]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}