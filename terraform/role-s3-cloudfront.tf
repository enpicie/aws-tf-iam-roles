resource "aws_iam_role" "github_actions_s3_cloudfront" {
  name               = "tf-cloudfront-s3"
  description        = "Assumed by GitHub Actions workflows to provision S3 and CloudFront resources for static web hosting"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions_s3_cloudfront_s3" {
  role       = aws_iam_role.github_actions_s3_cloudfront.name
  policy_arn = aws_iam_policy.s3_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_s3_cloudfront_cloudfront" {
  role       = aws_iam_role.github_actions_s3_cloudfront.name
  policy_arn = aws_iam_policy.cloudfront_full_access.arn
}

resource "github_actions_organization_secret" "aws_role_arn_s3_cloudfront" {
  secret_name     = "AWS_ROLE_ARN_S3_CLOUDFRONT"
  visibility      = var.github_secret_visibility
  plaintext_value = aws_iam_role.github_actions_s3_cloudfront.arn
}
