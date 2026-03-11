resource "aws_iam_role" "github_actions_lambda_apigw_ddb" {
  name               = "tf-apigw-ddb-lambda"
  description        = "Assumed by GitHub Actions workflows to provision Lambda, API Gateway, and DynamoDB resources"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions_lambda_apigw_ddb_lambda" {
  role       = aws_iam_role.github_actions_lambda_apigw_ddb.name
  policy_arn = aws_iam_policy.lambda_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_lambda_apigw_ddb_apigw" {
  role       = aws_iam_role.github_actions_lambda_apigw_ddb.name
  policy_arn = aws_iam_policy.apigw_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_lambda_apigw_ddb_dynamodb" {
  role       = aws_iam_role.github_actions_lambda_apigw_ddb.name
  policy_arn = aws_iam_policy.dynamodb_full_access.arn
}

resource "github_actions_organization_secret" "aws_role_arn_lambda_apigw_ddb" {
  secret_name     = "AWS_ROLE_ARN_LAMBDA_APIGW_DDB"
  visibility      = var.github_secret_visibility
  plaintext_value = aws_iam_role.github_actions_lambda_apigw_ddb.arn
}
