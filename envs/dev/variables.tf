# VPC
variable "cidr_block" {}
variable "vpc_name" {}
variable "internet_gateway_name" {}
variable "nat_gateway" {}
variable "public_subnets" {}
variable "private_subnets" {}

# S3
variable "bucket_name" {}

# RDS
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}

# EC2
variable "iam_read_only_role_name" {}
variable "instance_ami" {}
variable "instance_type" {}
variable "private_instance_names" {}

# ALB
# Nothing here 