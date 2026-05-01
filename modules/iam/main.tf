resource "aws_iam_role" "s3_read_only_access" {
  name = "s3-read-only-access-for-instances"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "sts:AssumeRole"
          ],
          "Principal" : {
            "Service" : [
              "ec2.amazonaws.com"
            ]
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "s3_read_only_attachment" {
    role = aws_iam_role.s3_read_only_access.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
