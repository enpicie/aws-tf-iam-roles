resource "aws_iam_policy" "cloudwatch_full_access" {
  name        = "CloudWatchFullAccess"
  description = "Full access to AWS CloudWatch metrics and CloudWatch Logs"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "CloudWatchFullAccess",
        Effect   = "Allow",
        Action   = ["cloudwatch:*", "logs:*"],
        Resource = "*"
      },
      {
        # SNS topics are the standard target for CloudWatch alarm actions
        # (e.g. notify on ALARM/OK state). Full SNS access is scoped here to
        # the operations needed to manage alarm notification topics.
        Sid    = "SNSForCloudWatchAlarms",
        Effect = "Allow",
        Action = [
          "sns:CreateTopic",
          "sns:DeleteTopic",
          "sns:GetTopicAttributes",
          "sns:SetTopicAttributes",
          "sns:Subscribe",
          "sns:Unsubscribe",
          "sns:ListTopics",
          "sns:ListSubscriptionsByTopic",
          "sns:TagResource"
        ],
        Resource = "*"
      },
      {
        # Allows passing and creating the IAM role that CloudWatch uses to deliver
        # metrics to Kinesis Firehose via CloudWatch metric streams.
        Sid    = "IAMForCloudWatchMetricStreams",
        Effect = "Allow",
        Action = [
          "iam:CreateRole",
          "iam:GetRole",
          "iam:PassRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:DeleteRole",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies"
        ],
        Resource = "arn:aws:iam::637423387388:role/CloudWatchMetricStreamRole-*"
      },
      {
        # Required to create the CloudWatch Application Insights service-linked role.
        Sid      = "IAMServiceLinkedRoleForCloudWatch",
        Effect   = "Allow",
        Action   = ["iam:CreateServiceLinkedRole"],
        Resource = "arn:aws:iam::637423387388:role/aws-service-role/application-insights.cloudwatch.amazonaws.com/*",
        Condition = {
          StringLikeIfExists = {
            "iam:AWSServiceName" = "application-insights.cloudwatch.amazonaws.com"
          }
        }
      }
    ]
  })
}
