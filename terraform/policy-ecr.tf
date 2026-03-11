resource "aws_iam_policy" "ecr_full_access" {
  name        = "ECRFullAccess"
  description = "Full access to AWS ECR (private and public)"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "ECRPrivateFullAccess",
        Effect   = "Allow",
        Action   = ["ecr:*"],
        Resource = "*"
      },
      {
        Sid      = "ECRPublicFullAccess",
        Effect   = "Allow",
        Action   = ["ecr-public:*"],
        Resource = "*"
      },
      {
        # sts:GetServiceBearerToken is required to authenticate with the ECR public
        # gallery (ecr-public:GetAuthorizationToken calls STS under the hood).
        Sid      = "STSForECRPublicAuth",
        Effect   = "Allow",
        Action   = ["sts:GetServiceBearerToken"],
        Resource = "*"
      },
      {
        # KMS customer-managed keys used for ECR repository encryption at rest.
        Sid    = "KMSForECREncryption",
        Effect = "Allow",
        Action = [
          "kms:CreateKey",
          "kms:DescribeKey",
          "kms:EnableKeyRotation",
          "kms:GetKeyPolicy",
          "kms:PutKeyPolicy",
          "kms:CreateAlias",
          "kms:DeleteAlias",
          "kms:ListAliases"
        ],
        Resource = "*"
      },
      {
        # Required to create the ECR replication service-linked role on first use.
        Sid      = "IAMServiceLinkedRoleForECR",
        Effect   = "Allow",
        Action   = ["iam:CreateServiceLinkedRole"],
        Resource = "arn:aws:iam::637423387388:role/aws-service-role/replication.ecr.amazonaws.com/*",
        Condition = {
          StringLikeIfExists = {
            "iam:AWSServiceName" = "replication.ecr.amazonaws.com"
          }
        }
      }
    ]
  })
}
