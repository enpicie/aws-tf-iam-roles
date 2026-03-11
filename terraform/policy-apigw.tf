resource "aws_iam_policy" "apigw_full_access" {
  name        = "APIGatewayFullAccess"
  description = "Full access to AWS API Gateway"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "APIGatewayFullAccess",
        Effect   = "Allow",
        Action   = ["apigateway:*", "execute-api:*"],
        Resource = "*"
      },
      {
        # API Gateway writes execution and access logs to CloudWatch Logs.
        # These permissions are required to create log groups for stages and
        # to configure the account-level CloudWatch logging role.
        Sid    = "CloudWatchLogsForAPIGateway",
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:DescribeLogGroups",
          "logs:CreateLogDelivery",
          "logs:GetLogDelivery",
          "logs:UpdateLogDelivery",
          "logs:DeleteLogDelivery",
          "logs:ListLogDeliveries",
          "logs:PutResourcePolicy",
          "logs:DescribeResourcePolicies",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "*"
      },
      {
        # Allows passing and managing the IAM role that API Gateway assumes
        # to write logs to CloudWatch. Required when setting the account-level
        # CloudWatch role ARN via aws_api_gateway_account.
        Sid    = "IAMForAPIGatewayCloudWatchRole",
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
        Resource = "arn:aws:iam::637423387388:role/APIGatewayCloudWatchRole-*"
      },
      {
        # Needed to associate ACM certificates with API Gateway custom domain names.
        Sid    = "ACMForCustomDomains",
        Effect = "Allow",
        Action = [
          "acm:ListCertificates",
          "acm:DescribeCertificate"
        ],
        Resource = "*"
      }
    ]
  })
}
