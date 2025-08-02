data "aws_iam_policy_document" "assume_role_policy_oidc_gha_admin" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:ulfiac/aws-bootstrap:*"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc_gha.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "oidc_gha_admin" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_oidc_gha_admin.json
  name               = local.role_name_admin
}

data "aws_iam_policy" "admin_access" {
  name = "AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "oidc_gha_admin" {
  role       = aws_iam_role.oidc_gha_admin.name
  policy_arn = data.aws_iam_policy.admin_access.arn
}
