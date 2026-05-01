output "vpc_id" {
    value = aws_vpc.main.id
}

output "bastion_host_sg_id" {
    value = aws_security_group.bastion_host_sg.id
}

output "springboot_sg_id" {
    value = aws_security_group.springboot_ec2_sg.id
}

output "fastapi_sg_id" {
    value = aws_security_group.fastapi_ec2_sg.id
}

output "rds_sg_id" {
    value = aws_security_group.rds_sg.id
}

output "alb_sg_id" {
    value = aws_security_group.alb_sg.id
}

output "bastion_host_subnet_id" {
    value = values(aws_subnet.public)[0].id
}

output "public_subnet_ids" {
    value = values(aws_subnet.public)[*].id
}

output "private_subnet_ids" {
    value = values(aws_subnet.private)[*].id
}