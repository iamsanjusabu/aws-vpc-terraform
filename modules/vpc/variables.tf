variable "vpc_name" {
  type = string
}

variable "cidr_block" {
  description = "ipv4 addresses to be allocated"

  type = string
}

variable "internet_gateway_name" {
  type = string
}

# 2 of these
variable "public_subnet" {
  type = map(object(
    { cidr = string,
    az = string }
  ))
}

# 2 of these
variable "private_subnet" {
  type = map(object({ cidr = string, az = string, nat_gateway_key = string }))
}


# 2 of these
# public_subnet_key should be the same as key name of public_subnet
variable "nat_gateway" {
  type =  map(object({public_subnet_key = string, eip_name = string}))
} 