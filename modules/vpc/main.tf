# aws vpc
resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

# aws vpc internet-gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.internet_gateway_name
  }
}

# aws vpc public subnet
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id

  for_each          = var.public_subnets
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}

# aws vpc private subnet 
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id

  for_each          = var.private_subnets
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}

# aws vpc route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Connection inside the vpc for subnet resources
  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local"
  }

  # Connection to the internet ipv4 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  for_each = var.nat_gateway
  # Connection inside the vpc for subnet resources
  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway[each.key].id
  }

  tags = {
    Name = "private-rt-${each.key}"
  }
}

# aws vpc route table association 
resource "aws_route_table_association" "public" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.value.nat_gateway_key].id
}

# aws vpc nat gateway
resource "aws_eip" "eip" {
  for_each = var.nat_gateway
  tags = {
    Name = "${each.value.eip_name}-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  for_each      = var.nat_gateway
  allocation_id = aws_eip.eip[each.key].id
  subnet_id     = aws_subnet.public[each.value.public_subnet_key].id

  tags = {
    Name = each.key
  }
}

# Security groups

# alb-sg
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  name        = "alb-sg"
  description = "Allow inbound to port 80 and outbound to the private subnets port 8080"
  tags = {
    Name = "alb-sg"
  }
}

# alb inbound 
resource "aws_vpc_security_group_ingress_rule" "alb_sg_inbound_ipv4" {
  security_group_id = aws_security_group.alb_sg.id

  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
}


# alb outbound
resource "aws_vpc_security_group_egress_rule" "alb_sg_outbound" {
  security_group_id = aws_security_group.alb_sg.id

  ip_protocol                  = "tcp"
  to_port                      = 8080
  from_port                    = 8080
  referenced_security_group_id = aws_security_group.springboot_ec2_sg.id
}

# bastion-host-sg
resource "aws_security_group" "bastion_host_sg" {
  vpc_id = aws_vpc.main.id

  name        = "bastion-host-sg"
  description = "Allow ssh access to MY IP and allow bastion host to access port 22 of other ec2s in the vpc"
  tags = {
    Name = "bastion-host-sg"
  }
}

# bastion-host inbound
resource "aws_vpc_security_group_ingress_rule" "bastion_host_sg_ssh_inbound" {
  security_group_id = aws_security_group.bastion_host_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "103.148.20.7/32"
}

# bastion-host outbound
resource "aws_vpc_security_group_egress_rule" "bastion_host_sg_ipv4_outbound" {
  security_group_id = aws_security_group.bastion_host_sg.id
  ip_protocol       = "-1"

  cidr_ipv4 = "0.0.0.0/0"
}


# rds-sg
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

  name        = "rds-sg"
  description = "Allow SSH and port 5432 access inbound and NAT gateway outbound"

  tags = {
    Name = "rds-sg"
  }
}

#rds inbound
resource "aws_vpc_security_group_ingress_rule" "rds_sg_ssh_inbound" {
  security_group_id = aws_security_group.rds_sg.id

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22

  referenced_security_group_id = aws_security_group.bastion_host_sg.id
}

# rds inbound
resource "aws_vpc_security_group_ingress_rule" "rds_sg_inbound" {
  security_group_id = aws_security_group.rds_sg.id

  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432

  referenced_security_group_id = aws_security_group.springboot_ec2_sg.id
}

#rds outbound
resource "aws_vpc_security_group_egress_rule" "rds_sg_ipv4_outbound" {
  security_group_id = aws_security_group.rds_sg.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}


# springboot-sg
resource "aws_security_group" "springboot_ec2_sg" {
  vpc_id = aws_vpc.main.id

  name        = "springboot-sg"
  description = "Allow inbound to 8080 and outbound to NAT gateway and also ssh access to bastion host"
  tags = {
    Name = "springboot-sg"
  }
}

# springboot inbound
resource "aws_vpc_security_group_ingress_rule" "springboot_sg_inbound" {
  security_group_id = aws_security_group.springboot_ec2_sg.id

  ip_protocol = "tcp"
  from_port   = 8080
  to_port     = 8080

  referenced_security_group_id = aws_security_group.alb_sg.id
}

# springboot inbound
resource "aws_vpc_security_group_ingress_rule" "springboot_sg_ssh_inbound" {
  security_group_id = aws_security_group.springboot_ec2_sg.id

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22

  referenced_security_group_id = aws_security_group.bastion_host_sg.id
}

# springboot outbound
resource "aws_vpc_security_group_egress_rule" "springboot_sg_ipv4_outbound" {
  security_group_id = aws_security_group.springboot_ec2_sg.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}


# fastapi-sg
resource "aws_security_group" "fastapi_ec2_sg" {
  vpc_id = aws_vpc.main.id

  name        = "fastapi-sg"
  description = "SSH access to bastion host and port 8000 access to springboot"

  tags = {
    Name = "fastapi-sg"
  }
}

# fastapi inbound
resource "aws_vpc_security_group_ingress_rule" "fastapi_sg_ssh_inbound" {
  security_group_id = aws_security_group.fastapi_ec2_sg.id

  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
  referenced_security_group_id = aws_security_group.bastion_host_sg.id
}

# fastapi inbound
resource "aws_vpc_security_group_ingress_rule" "fastapi_sg_springboot_inbound" {
  security_group_id = aws_security_group.fastapi_ec2_sg.id

  ip_protocol                  = "tcp"
  from_port                    = 8000
  to_port                      = 8000
  referenced_security_group_id = aws_security_group.springboot_ec2_sg.id
}

# fastapi outbound
resource "aws_vpc_security_group_egress_rule" "fastapi_sg_ipv4_outbound" {
  security_group_id = aws_security_group.fastapi_ec2_sg.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}
