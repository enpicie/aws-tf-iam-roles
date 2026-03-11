resource "aws_iam_policy" "lambda_full_access" {
  name        = "LambdaFullAccess"
  description = "Full access to AWS Lambda"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "LambdaFullAccess",
        Effect   = "Allow",
        Action   = ["lambda:*"],
        Resource = "*"
      },
      {
        # Needed to allow Lambda functions to access S3 buckets for deployment artifacts.
        # The need for this is implied in creation of lambdas so S3 is not included in role name.
        Sid    = "S3AccessForLambdaDeployment",
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::enpicie-dev-lambda-artifacts",
          "arn:aws:s3:::enpicie-dev-lambda-artifacts/*",
          "arn:aws:s3:::enpicie-prod-lambda-artifacts",
          "arn:aws:s3:::enpicie-prod-lambda-artifacts/*"
        ]
      },
      {
        # Allows creating, updating, and destroying the IAM execution role that Lambda
        # functions assume at runtime. Scoped to the LambdaExecutionRole-* naming convention.
        # DetachRolePolicy is required for Terraform to cleanly destroy or replace roles.
        Sid    = "IAMManageForLambdaExecutionRole",
        Effect = "Allow",
        Action = [
          "iam:CreateRole",
          "iam:GetRole",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfilesForRole",
          "iam:TagRole",
          "iam:UntagRole"
        ],
        Resource = "arn:aws:iam::637423387388:role/LambdaExecutionRole-*"
      },
      {
        # Allows passing the execution role to Lambda. Scoped by service to prevent
        # this PassRole from being used to escalate privileges to other services.
        Sid    = "PassRoleForLambda",
        Effect = "Allow",
        Action = "iam:PassRole",
        Resource = "arn:aws:iam::637423387388:role/LambdaExecutionRole-*",
        Condition = {
          StringEquals = {
            "iam:PassedToService" = "lambda.amazonaws.com"
          }
        }
      },
      {
        # Manages CloudWatch log groups for Lambda functions. PutRetentionPolicy is
        # needed by Terraform to set log retention. DeleteLogGroup is needed on destroy.
        Sid    = "CloudWatchLogsForLambda",
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:DescribeLogGroups",
          "logs:PutRetentionPolicy",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        # KMS customer-managed keys used to encrypt Lambda environment variables
        # and, when applicable, the deployment package at rest.
        Sid    = "KMSForLambdaEncryption",
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
        # VPC-deployed Lambda functions require network interfaces in the target subnets.
        # Terraform needs describe access to look up VPC context and create/delete ENIs.
        Sid    = "EC2NetworkingForVPCLambda",
        Effect = "Allow",
        Action = [
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:AssignPrivateIpAddresses",
          "ec2:UnassignPrivateIpAddresses"
        ],
        Resource = "*"
      },
      {
        # Required to create the Lambda VPC access service-linked role on first use.
        # This role allows Lambda to manage ENIs in the VPC on the function's behalf.
        Sid      = "IAMServiceLinkedRoleForLambdaVPC",
        Effect   = "Allow",
        Action   = ["iam:CreateServiceLinkedRole"],
        Resource = "arn:aws:iam::637423387388:role/aws-service-role/lambda.amazonaws.com/*",
        Condition = {
          StringLikeIfExists = {
            "iam:AWSServiceName" = "lambda.amazonaws.com"
          }
        }
      }
    ]
  })
}
