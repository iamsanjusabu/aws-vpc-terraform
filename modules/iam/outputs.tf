output "iam_read_only_role_name" {
    value = aws_iam_role.s3_read_only_access.name
}