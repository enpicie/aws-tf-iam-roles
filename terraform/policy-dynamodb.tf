resource "aws_iam_policy" "dynamodb_full_access" {
  name        = "DynamoDBFullAccess"
  description = "Full access to AWS DynamoDB"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "DynamoDBFullAccess",
        Effect   = "Allow",
        Action   = ["dynamodb:*"],
        Resource = "*"
      },
      {
        # DynamoDB auto-scaling delegates to Application Auto Scaling, which
        # requires these permissions to register targets and manage scaling policies.
        Sid    = "AutoScalingForDynamoDB",
        Effect = "Allow",
        Action = [
          "application-autoscaling:RegisterScalableTarget",
          "application-autoscaling:DeregisterScalableTarget",
          "application-autoscaling:DescribeScalableTargets",
          "application-autoscaling:PutScalingPolicy",
          "application-autoscaling:DeleteScalingPolicy",
          "application-autoscaling:DescribeScalingPolicies"
        ],
        Resource = "*"
      },
      {
        # Allows passing the auto-scaling service-linked role to Application Auto Scaling
        # and creating it if it does not already exist in the account.
        Sid    = "IAMForDynamoDBAutoScaling",
        Effect = "Allow",
        Action = [
          "iam:CreateServiceLinkedRole",
          "iam:PassRole"
        ],
        Resource = [
          "arn:aws:iam::637423387388:role/aws-service-role/dynamodb.application-autoscaling.amazonaws.com/*"
        ]
      },
      {
        # CloudWatch alarms are commonly provisioned alongside DynamoDB tables
        # to alert on consumed capacity, throttled requests, and latency.
        Sid    = "CloudWatchAlarmsForDynamoDB",
        Effect = "Allow",
        Action = [
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DeleteAlarms",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics"
        ],
        Resource = "*"
      },
      {
        # KMS customer-managed keys used for DynamoDB encryption at rest.
        Sid    = "KMSForDynamoDBEncryption",
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
