resource "aws_iam_user" "admin_user" {
  name          = "ulfiac"
  force_destroy = true
}

data "aws_iam_policy" "admin_access" {
  name = "AdministratorAccess"
}

resource "aws_iam_user_policy_attachment" "admin_user" {
  user       = aws_iam_user.admin_user.name
  policy_arn = data.aws_iam_policy.admin_access.arn
}
