# VPC
output "vpc_id" {
    value = module.vpc.vpc_id
}

output "springboot_sg_id" {
    value = module.vpc.springboot_sg_id
}

output "fastapi_sg_id" {
    value = module.vpc.fastapi_sg_id
}

output "rds_sg_id" {
    value = module.vpc.rds_sg_id
}

output "alb_sg_id" {
    value = module.vpc.alb_sg_id
}

output "bastion_host_subnet_id" {
    value = module.vpc.bastion_host_subnet_id
}

output "public_subnet_ids" {
    value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
    value = module.vpc.private_subnet_ids
}

# S3
output "bucket_name" {
    value = module.s3.bucket_name
}

output "bucket_arn" {
    value = module.s3.bucket_arn
}

# RDS
output "rds_endpoint" {
    value = module.rds.rds_endpoint
}

# EC2
output "application_instances_private_ip" {
    value = module.ec2.application_instances_private_ip
}

output "springboot_instances_id" {
    value = module.ec2.springboot_instances_id
}

# ALB
output "alb_dns_name" {
    value = module.alb.alb_dns_name
}
