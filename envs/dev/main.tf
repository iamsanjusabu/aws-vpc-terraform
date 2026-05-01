module "vpc" {
    source = "../../modules/vpc"
    cidr_block = var.cidr_block
    vpc_name = var.vpc_name
    internet_gateway_name = var.internet_gateway_name
    nat_gateway = var.nat_gateway
    public_subnets = var.public_subnets
    private_subnets = var.private_subnets
}

module "s3" {
    source = "../../modules/s3"
    bucket_name = var.bucket_name
}

module "rds" {
    source = "../../modules/rds"
    db_name = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    private_subnet_ids = module.vpc.private_subnet_ids
    rds_security_group_id = module.vpc.rds_sg_id
}

module "iam" {
    source = "../../modules/iam"
}

module "ec2" {
    source = "../../modules/ec2"
    bastion_host_sg_id =  module.vpc.bastion_host_sg_id
    bastion_host_subnet_id = module.vpc.bastion_host_subnet_id
    fastapi_sg_id = module.vpc.fastapi_sg_id
    iam_read_only_role_name = var.iam_read_only_role_name
    instance_ami = var.instance_ami
    instance_type = var.instance_type
    instance_info = {
        "subnet1" = {subnet_id = module.vpc.private_subnet_ids[0], private_instance_name = "private-instance-1"}
        "subnet2" = {subnet_id = module.vpc.private_subnet_ids[1], private_instance_name = "private-instance-2"}
    }
    private_instance_names = var.private_instance_names
    springboot_sg_id = module.vpc.springboot_sg_id
}
module "alb" {
    source = "../../modules/alb"
    vpc_id = module.vpc.vpc_id
    alb_sg_id = module.vpc.alb_sg_id
    public_subnet_ids = module.vpc.public_subnet_ids
    springboot_instances_id = module.ec2.springboot_instances_id
}