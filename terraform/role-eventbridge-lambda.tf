resource "aws_iam_role" "github_actions_eventbridge_lambda" {
  name               = "tf-eventbridge-lambda"
  description        = "Assumed by GitHub Actions workflows to provision EventBridge scheduled Lambda resources"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions_eventbridge_lambda_eventbridge" {
  role       = aws_iam_role.github_actions_eventbridge_lambda.name
  policy_arn = aws_iam_policy.eventbridge_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_eventbridge_lambda_lambda" {
  role       = aws_iam_role.github_actions_eventbridge_lambda.name
  policy_arn = aws_iam_policy.lambda_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_eventbridge_lambda_tf_backend" {
  role       = aws_iam_role.github_actions_eventbridge_lambda.name
  policy_arn = aws_iam_policy.tf_backend.arn
}

resource "github_actions_organization_secret" "aws_role_arn_eventbridge_lambda" {
  secret_name     = "AWS_ROLE_ARN_EVENTBRIDGE_LAMBDA"
  visibility      = var.github_secret_visibility
  plaintext_value = aws_iam_role.github_actions_eventbridge_lambda.arn
}
