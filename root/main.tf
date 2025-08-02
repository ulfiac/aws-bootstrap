data "aws_caller_identity" "current" {}

data "aws_kms_key" "aws_s3_key" {
  key_id = "alias/aws/s3"
}

locals {
  bucket_name     = "ulfiac-terraform-state"
  role_name_admin = "ulfiac-oidc-gha-admin"
}
