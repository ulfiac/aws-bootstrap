variable "oidc_role_to_assume" {
  description = "The name of the IAM role to be assumed by OIDC-auth'ed GitHub Actions."
  type        = string
}

variable "test_terraform_docs_bootstrap_module" {
  description = "Whether to test the terraform-docs generation for the bootstrap module. This is useful to ensure that the documentation is up-to-date and correctly generated."
  type        = bool
  default     = true
}
