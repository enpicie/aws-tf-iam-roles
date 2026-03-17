resource "aws_iam_policy" "eventbridge_full_access" {
  name        = "EventBridgeFullAccess"
  description = "Full access to AWS EventBridge"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "EventBridgeFullAccess",
        Effect = "Allow",
        Action = [
          "events:PutRule",
          "events:DescribeRule",
          "events:DeleteRule",
          "events:EnableRule",
          "events:DisableRule",
          "events:ListRules",
          "events:PutTargets",
          "events:RemoveTargets",
          "events:ListTargetsByRule",
          "events:ListTagsForResource",
          "events:TagResource",
          "events:UntagResource"
        ],
        Resource = "*"
      }
    ]
  })
}
