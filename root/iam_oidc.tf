import {
  for_each = local.import_oidc_gha
  to       = aws_iam_openid_connect_provider.oidc_gha
  id       = each.value
}

resource "aws_iam_openid_connect_provider" "oidc_gha" {
  client_id_list = ["sts.amazonaws.com"]
  url            = "https://token.actions.githubusercontent.com"
}
