output "application_instances_private_ip" {
    value = values(aws_instance.application_instances)[*].private_ip
}

output "springboot_instances_id" {
    value = values(aws_instance.application_instances)[*].id
}