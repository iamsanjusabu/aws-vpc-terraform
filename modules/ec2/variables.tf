
# A means injected from output


# A
variable "iam_read_only_role_name" {
    description = "Role name of the IAM which has s3 read only access"
    type = string
}

variable "instance_ami" {
    description = "AMI ID"
    type = string

    default = "ami-07a00cf47dbbc844c"
}

variable "instance_type" {
    description = "instance type (t3.micro)"
    type = string
    default = "t3.micro"
}

# A
variable "springboot_sg_id" {
    description = "Springboot security group id passed from the vpc module"
    type = string
}

# A
variable "fastapi_sg_id" {
    description = "FastAPI security group id passed from the vpc module"
    type = string
}

# A
variable "bastion_host_sg_id" {
    description = "Bastion host security group id passed from the vpc module"
    type = string
}

variable "instance_info" {
    description = "subnet id and private instance name"
    type = map(object({ subnet_id= string, private_instance_name = string }))
}

variable "private_instance_names" {
    description = "set of private instance names"
    type = set(string)
}

# A
variable "bastion_host_subnet_id" {
    description = "subnet id of the public subnet where bastion host should exist"
    type = string
}