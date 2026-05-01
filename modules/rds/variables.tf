# A
variable "private_subnet_ids" {
    description = "All the subnets where db should have access"
    type = set(string)
}

variable "db_name" {
    description = "Name of the DB"
    type = string
}

variable "db_username" {
    description = "Master username"
    type = string
}

variable "db_password" {
    description = "DB password"
    type = string
    sensitive = true
}

# A
variable "rds_security_group_id" {
    description = "Security group id of RDS"
    type = string
}