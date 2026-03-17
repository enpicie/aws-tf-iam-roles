resource "aws_iam_role" "github_actions_eventbridge_lambda_ddb_sqs" {
  name               = "tf-eventbridge-lambda-ddb-sqs"
  description        = "Assumed by GitHub Actions workflows to provision EventBridge scheduled Lambda resources with DynamoDB and SQS"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions_eventbridge_lambda_ddb_sqs_eventbridge" {
  role       = aws_iam_role.github_actions_eventbridge_lambda_ddb_sqs.name
  policy_arn = aws_iam_policy.eventbridge_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_eventbridge_lambda_ddb_sqs_lambda" {
  role       = aws_iam_role.github_actions_eventbridge_lambda_ddb_sqs.name
  policy_arn = aws_iam_policy.lambda_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_eventbridge_lambda_ddb_sqs_ddb" {
  role       = aws_iam_role.github_actions_eventbridge_lambda_ddb_sqs.name
  policy_arn = aws_iam_policy.dynamodb_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_eventbridge_lambda_ddb_sqs_sqs" {
  role       = aws_iam_role.github_actions_eventbridge_lambda_ddb_sqs.name
  policy_arn = aws_iam_policy.sqs_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_eventbridge_lambda_ddb_sqs_secretsmanager" {
  role       = aws_iam_role.github_actions_eventbridge_lambda_ddb_sqs.name
  policy_arn = aws_iam_policy.secretsmanager_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_eventbridge_lambda_ddb_sqs_tf_backend" {
  role       = aws_iam_role.github_actions_eventbridge_lambda_ddb_sqs.name
  policy_arn = aws_iam_policy.tf_backend.arn
}

resource "github_actions_organization_secret" "aws_role_arn_eventbridge_lambda_ddb_sqs" {
  secret_name     = "AWS_ROLE_ARN_EVENTBRIDGE_LAMBDA_DDB_SQS"
  visibility      = var.github_secret_visibility
  plaintext_value = aws_iam_role.github_actions_eventbridge_lambda_ddb_sqs.arn
}
