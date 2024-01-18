variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
  type = list
}

variable "image_id" {
  type = string
}

variable "key_name" {
  type = string
  default = "mykey"
}

variable "security_group_id" {
  type = string
}