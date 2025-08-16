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

data "local_file" "pgp_key" {
  filename = abspath("./public_key_binary.gpg")
}

resource "aws_iam_user_login_profile" "admin_user" {
  pgp_key                 = data.local_file.pgp_key.content_base64
  password_length         = 42
  password_reset_required = true
  user                    = aws_iam_user.admin_user.name
}

output "encrypted_password" {
  value = aws_iam_user_login_profile.admin_user.encrypted_password
}

output "local_file_pgp_key_content_sha256" {
  value = data.local_file.pgp_key.content_sha256
}

output "local_file_pgp_key_content_base64_sha256" {
  value = data.local_file.pgp_key.content_base64sha256
}
