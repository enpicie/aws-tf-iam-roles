resource "aws_iam_role" "github_actions_s3" {
  name               = "tf-s3"
  description        = "Assumed by GitHub Actions workflows to provision S3 resources"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions_s3_s3" {
  role       = aws_iam_role.github_actions_s3.name
  policy_arn = aws_iam_policy.s3_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_s3_tf_backend" {
  role       = aws_iam_role.github_actions_s3.name
  policy_arn = aws_iam_policy.tf_backend.arn
}

resource "github_actions_organization_secret" "aws_role_arn_s3" {
  secret_name     = "AWS_ROLE_ARN_S3"
  visibility      = var.github_secret_visibility
  plaintext_value = aws_iam_role.github_actions_s3.arn
}
