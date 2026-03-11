resource "aws_iam_role" "github_actions_lambda_apigw" {
  name               = "tf-apigw-lambda"
  description        = "Assumed by GitHub Actions workflows to provision Lambda and API Gateway resources"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions_lambda_apigw_lambda" {
  role       = aws_iam_role.github_actions_lambda_apigw.name
  policy_arn = aws_iam_policy.lambda_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_lambda_apigw_apigw" {
  role       = aws_iam_role.github_actions_lambda_apigw.name
  policy_arn = aws_iam_policy.apigw_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_lambda_apigw_tf_backend" {
  role       = aws_iam_role.github_actions_lambda_apigw.name
  policy_arn = aws_iam_policy.tf_backend.arn
}

resource "github_actions_organization_secret" "aws_role_arn_lambda_apigw" {
  secret_name     = "AWS_ROLE_ARN_LAMBDA_APIGW"
  visibility      = var.github_secret_visibility
  plaintext_value = aws_iam_role.github_actions_lambda_apigw.arn
}
