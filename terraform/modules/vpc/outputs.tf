output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "subnet_ids" {
  value = [for subnet in aws_subnet.main_sb : subnet.id]
}

output "image_id" {
  value = var.AWS_AMIS["default"]
  
}

output "sg_id" {
  value = aws_security_group.main_sg.id
}