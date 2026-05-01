variable "vpc_id" {
    description = "ID of the vpc"
    type = string
}


variable "alb_sg_id" {
    description = "Application Load Balancer (ALB) security group id"
    type = string
}

variable "public_subnet_ids" {
    description = "List of public subnet ids where load balancer node should exist"
    type = list(string)
}

variable "springboot_instances_id" {
    description = "Id of all the springboot instances"
    type = list(string)
}