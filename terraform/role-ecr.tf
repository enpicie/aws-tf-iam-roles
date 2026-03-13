resource "aws_iam_role" "github_actions_ecr" {
  name               = "tf-ecr"
  description        = "Assumed by GitHub Actions workflows to provision ECR repositories and push images"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions_ecr_ecr" {
  role       = aws_iam_role.github_actions_ecr.name
  policy_arn = aws_iam_policy.ecr_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_ecr_secretsmanager" {
  role       = aws_iam_role.github_actions_ecr.name
  policy_arn = aws_iam_policy.secretsmanager_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_ecr_tf_backend" {
  role       = aws_iam_role.github_actions_ecr.name
  policy_arn = aws_iam_policy.tf_backend.arn
}

resource "github_actions_organization_secret" "aws_role_arn_ecr" {
  secret_name     = "AWS_ROLE_ARN_ECR"
  visibility      = var.github_secret_visibility
  plaintext_value = aws_iam_role.github_actions_ecr.arn
}
