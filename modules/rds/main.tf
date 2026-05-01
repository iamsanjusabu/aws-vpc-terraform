resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "postgresql-subnet-group"

    subnet_ids = var.private_subnet_ids
    tags = {
        Name = "postgresql-subnet-group"
    }
}

# rds instance
resource "aws_db_instance" "postgresql" {
    identifier = "postgres-db"
    engine = "postgres"
    engine_version = "18.3"
    instance_class = "db.t4g.micro"

    db_name = var.db_name
    username = var.db_username
    password = var.db_password

    allocated_storage = 20
    storage_type = "gp3"
    skip_final_snapshot = true

    vpc_security_group_ids = [ var.rds_security_group_id ]
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

    publicly_accessible = false
    tags = {
        Name = "postgres-db"
    }
}