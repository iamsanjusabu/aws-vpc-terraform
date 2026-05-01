variable "vpc_name" {
  description = "Name of the VPC"
  type = string
}

variable "cidr_block" {
  description = "ipv4 addresses to be allocated for the VPC"
  type = string
}

variable "internet_gateway_name" {
  description = "Name of the internet gateway"
  type = string
}

# 2 of these
variable "public_subnets" {
  description = "CIDR and AZ of public subnet in MAP format"
  type = map(object({ cidr = string, az = string } ))
}

# 2 of these
variable "private_subnets" {
  description = "CIDR, AZ and NAT_GATEWAY_KEY (tf) of private subnet in MAP format"
  type = map(object({ cidr = string, az = string, nat_gateway_key = string }))
}


# 2 of these
# public_subnet_key should be the same as key name of public_subnet
variable "nat_gateway" {
  description = "Key of the public subnet (tf) and name of the Elastic IP"
  type = map(object({ public_subnet_key = string, eip_name = string }))
} 