variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnets_cidr" {
  type    = list
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "azs" {
  type        = list
  description = "AZs to use for subnets"
  default     = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}

variable "AWS_AMIS" {
    type = map
    default = {
        default = "ami-00983e8a26e4c9bd9"
    }
}