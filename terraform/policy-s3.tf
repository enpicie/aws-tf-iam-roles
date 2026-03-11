resource "aws_iam_policy" "s3_full_access" {
  name        = "S3FullAccess"
  description = "Full access to AWS S3"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "S3FullAccess",
        Effect   = "Allow",
        Action   = ["s3:*"],
        Resource = "*"
      },
      {
        # KMS customer-managed keys used for S3 server-side encryption (SSE-KMS).
        Sid    = "KMSForS3Encryption",
        Effect = "Allow",
        Action = [
          "kms:CreateKey",
          "kms:DescribeKey",
          "kms:EnableKeyRotation",
          "kms:GetKeyPolicy",
          "kms:PutKeyPolicy",
          "kms:CreateAlias",
          "kms:DeleteAlias",
          "kms:ListAliases",
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ],
        Resource = "*"
      },
      {
        # Allows passing and managing the IAM role that S3 assumes for cross-region
        # replication. Required when provisioning aws_s3_bucket_replication_configuration.
        Sid    = "IAMForS3Replication",
        Effect = "Allow",
        Action = [
          "iam:CreateRole",
          "iam:GetRole",
          "iam:PassRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:DeleteRole",
          "iam:CreatePolicy",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies"
        ],
        Resource = [
          "arn:aws:iam::637423387388:role/S3ReplicationRole-*",
          "arn:aws:iam::637423387388:policy/S3ReplicationPolicy-*"
        ]
      }
    ]
  })
}
