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
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::*-terraform-state",
          "arn:aws:s3:::*-terraform-state/*"
        ]
      },
      {
        # DynamoDB is used by Terraform for state locking to prevent
        # concurrent runs from corrupting the state file.
        Sid    = "DynamoDBStateLocking",
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ],
        Resource = "arn:aws:dynamodb:*:637423387388:table/terraform-state-locks"
      }
    ]
  })
}
