resource "aws_iam_policy" "sqs_full_access" {
  name        = "SQSFullAccess"
  description = "Full access to AWS SQS"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "SQSFullAccess",
        Effect   = "Allow",
        Action   = ["sqs:*"],
        Resource = "*"
      },
      {
        # KMS customer-managed keys used for SQS server-side encryption (SSE-KMS).
        Sid    = "KMSForSQSEncryption",
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
        # Read-only SNS access needed to inspect topics when configuring
        # SQS queues as SNS subscribers or when setting up DLQ notifications.
        Sid    = "SNSReadForSQSSubscriptions",
        Effect = "Allow",
        Action = [
          "sns:GetTopicAttributes",
          "sns:ListTopics",
          "sns:ListSubscriptionsByTopic"
        ],
        Resource = "*"
      },
      {
        # CloudWatch alarms are commonly provisioned alongside SQS queues
        # to alert on queue depth, message age, and DLQ message count.
        Sid    = "CloudWatchAlarmsForSQS",
        Effect = "Allow",
        Action = [
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DeleteAlarms",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics"
        ],
        Resource = "*"
      }
    ]
  })
}
