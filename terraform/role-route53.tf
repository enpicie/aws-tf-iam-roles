resource "aws_iam_role" "github_actions_route53" {
  name               = "tf-route53"
  description        = "Assumed by GitHub Actions workflows to provision Route 53 hosted zones and DNS records"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions_route53_route53" {
  role       = aws_iam_role.github_actions_route53.name
  policy_arn = aws_iam_policy.route53_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_route53_acm" {
  role       = aws_iam_role.github_actions_route53.name
  policy_arn = aws_iam_policy.acm_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_route53_tf_backend" {
  role       = aws_iam_role.github_actions_route53.name
  policy_arn = aws_iam_policy.tf_backend.arn
}

resource "github_actions_organization_secret" "aws_role_arn_route53" {
  secret_name     = "AWS_ROLE_ARN_ROUTE53"
  visibility      = var.github_secret_visibility
  plaintext_value = aws_iam_role.github_actions_route53.arn
}
