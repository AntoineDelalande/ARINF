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
  region = var.AWS_REGION
}

resource "aws_budgets_budget" "ambroke" {
  name              = "monthly-budget"
  budget_type       = "COST"
  limit_amount      = "10"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2023-09-01_00:00"
}

module "vpc" {
  source = "./modules/vpc"
}


module "lb" {
  source = "./modules/lb"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
  image_id = module.vpc.image_id
  security_group_id = module.vpc.sg_id
}
