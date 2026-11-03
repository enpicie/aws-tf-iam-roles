# Read-only access for reporting jobs that publish usage metrics.
#
# Deliberately separate from the deploy roles. A scheduled job that renders a
# public metrics page should not be able to assume a role carrying ecs:*,
# elasticloadbalancing:* and secretsmanager:*, which is what it would inherit
# from tf-alb-ecs. Nothing here can mutate any resource.
resource "aws_iam_policy" "metrics_read" {
  name        = "MetricsReadOnly"
  description = "Read-only CloudWatch metrics and Logs Insights access for scheduled usage-reporting jobs"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "CloudWatchMetricsRead",
        Effect = "Allow",
        Action = [
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics"
        ],
        Resource = "*"
      },
      {
        # StopQuery is included so a job that times out can clean up after
        # itself rather than leaving queries running against the account quota.
        Sid    = "LogsInsightsRead",
        Effect = "Allow",
        Action = [
          "logs:StartQuery",
          "logs:GetQueryResults",
          "logs:StopQuery",
          "logs:DescribeLogGroups",
          "logs:DescribeMetricFilters"
        ],
        Resource = "*"
      }
    ]
  })
}
