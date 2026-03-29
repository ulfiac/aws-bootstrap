variable "oidc_role_to_assume" {
  description = "The name of the IAM role to be assumed by OIDC-auth'ed GitHub Actions."
  type        = string
}

variable "aws_environment" {
  description = "The name of the GitHub environment for the AWS account."
  type        = string
}
