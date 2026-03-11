resource "aws_iam_policy" "tf_backend" {
  name        = "TerraformBackendAccess"
  description = "Allows Terraform to read and write state to S3 and acquire state locks via DynamoDB"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "S3StateAccess",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:HeadObject"
        ],
        Resource = [
          "arn:aws:s3:::*-terraform-state",
          "arn:aws:s3:::*-terraform-state/*"
        ]
      },
      {
        Sid    = "DynamoDBStateLocking",
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable"
        ],
        Resource = "arn:aws:dynamodb:*:637423387388:table/terraform-state-locks"
      }
    ]
  })
}
