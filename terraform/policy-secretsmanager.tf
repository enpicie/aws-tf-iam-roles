resource "aws_iam_policy" "secretsmanager_full_access" {
  name        = "SecretsManagerFullAccess"
  description = "Full access to AWS Secrets Manager for provisioning and managing secrets"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "SecretsManagerFullAccess",
        Effect   = "Allow",
        Action   = ["secretsmanager:*"],
        Resource = "*"
      },
      {
        # KMS customer-managed keys used to encrypt secrets at rest. Terraform needs
        # these to create/update secrets that specify a custom kms_key_id, and to
        # read key metadata during plan.
        Sid    = "KMSForSecretsManagerEncryption",
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
      }
    ]
  })
}
