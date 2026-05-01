resource "aws_s3_bucket" "tf_s3_bucket" {
    bucket = var.bucket_name   
}


resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.tf_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Springboot jar file copy to s3
resource "aws_s3_object" "springboot" {
    bucket = aws_s3_bucket.tf_s3_bucket.id

    key = "springboot/spring-boot-api.jar"
    source = "../../applications/spring-boot-api.jar"
    etag = filemd5("../../applications/spring-boot-api.jar")
}


# Fastapi folder copy to s3
resource "aws_s3_object" "fastapi" {
    bucket = aws_s3_bucket.tf_s3_bucket.id

    for_each = fileset("../../applications/fastapi", "**")
    key = "fastapi/${each.value}"
    source = "../../applications/fastapi/${each.value}"
    etag = filemd5("../../applications/fastapi/${each.value}")
}
