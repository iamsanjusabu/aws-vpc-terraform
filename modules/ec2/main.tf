resource "aws_iam_instance_profile" "iam_s3_read_only_profile" {
    name = "iam-s3-read-only-instance-profile"
    role = var.iam_read_only_role_name
}

resource "tls_private_key" "ed25519_key" {
    algorithm = "ED25519"
}

resource "local_sensitive_file" "local_key" {
    filename = "../../public_key.pem"
    content = tls_private_key.ed25519_key.private_key_openssh
}

resource "aws_key_pair" "tf_instances_key" {
    key_name = "application-instances-public-key"
    public_key = tls_private_key.ed25519_key.public_key_openssh
}


# springboot instances (2)
resource "aws_instance" "application_instances" {
    for_each = var.instance_info

    iam_instance_profile = aws_iam_instance_profile.iam_s3_read_only_profile.name
    subnet_id = each.value.subnet_id
    ami = var.instance_ami
    instance_type = var.instance_type
    
    vpc_security_group_ids = [ var.springboot_sg_id, var.fastapi_sg_id ]
    
    key_name = aws_key_pair.tf_instances_key.key_name
    
    root_block_device {
      volume_size = 15
      volume_type = "gp3"
    }
    tags = {
        Name = each.value.private_instance_name
    }
}

# bastion-host
resource "aws_instance" "bastion_host" {
    ami = var.instance_ami
    instance_type = var.instance_type
    
    subnet_id = var.bastion_host_subnet_id
    vpc_security_group_ids = [ var.bastion_host_sg_id ]
    
    key_name = aws_key_pair.tf_instances_key.key_name

    root_block_device {
        volume_size = 10
        volume_type = "gp3"
    }
    tags = {
        Name = "bastion-host"
    }
}