resource "aws_iam_role" "github_actions_metrics_read" {
  name               = "gh-metrics-read"
  description        = "Assumed by scheduled GitHub Actions jobs that read CloudWatch metrics and logs to publish usage reports. Read-only."
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions_metrics_read" {
  role       = aws_iam_role.github_actions_metrics_read.name
  policy_arn = aws_iam_policy.metrics_read.arn
}

resource "github_actions_organization_secret" "aws_role_arn_metrics_read" {
  secret_name     = "AWS_ROLE_ARN_METRICS_READ"
  visibility      = var.github_secret_visibility
  plaintext_value = aws_iam_role.github_actions_metrics_read.arn
}
