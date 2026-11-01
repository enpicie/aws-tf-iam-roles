data "aws_iam_policy_document" "github_oidc_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::637423387388:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # GitHub issues two subject formats: repos created before immutable
    # subjects use "repo:enpicie/<repo>:...", newer repos use
    # "repo:enpicie@<org id>/<repo>@<repo id>:...". Both patterns stop at the
    # org boundary; never use a bare "repo:enpicie*", which would also match
    # other accounts whose names start with "enpicie".
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:enpicie/*", "repo:enpicie@167734269/*"]
    }
  }
}
