resource "aws_iam_role" "github_actions_ecs_alb" {
  name               = "tf-alb-ecs"
  description        = "Assumed by GitHub Actions workflows to provision ECS and ALB resources for containerized backend services"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions_ecs_alb_ecs" {
  role       = aws_iam_role.github_actions_ecs_alb.name
  policy_arn = aws_iam_policy.ecs_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_ecs_alb_alb" {
  role       = aws_iam_role.github_actions_ecs_alb.name
  policy_arn = aws_iam_policy.alb_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_ecs_alb_acm" {
  role       = aws_iam_role.github_actions_ecs_alb.name
  policy_arn = aws_iam_policy.acm_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_ecs_alb_secretsmanager" {
  role       = aws_iam_role.github_actions_ecs_alb.name
  policy_arn = aws_iam_policy.secretsmanager_full_access.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_ecs_alb_tf_backend" {
  role       = aws_iam_role.github_actions_ecs_alb.name
  policy_arn = aws_iam_policy.tf_backend.arn
}

resource "github_actions_organization_secret" "aws_role_arn_ecs_alb" {
  secret_name     = "AWS_ROLE_ARN_ECS_ALB"
  visibility      = var.github_secret_visibility
  plaintext_value = aws_iam_role.github_actions_ecs_alb.arn
}
