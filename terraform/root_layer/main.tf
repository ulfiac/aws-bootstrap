data "aws_caller_identity" "current" {}

locals {
  bucket_name     = "ulfiac-terraform-state"
  role_name_admin = "ulfiac-oidc-gha-admin"
}
