# tf_state_bucket

Terraform module to create AWS infrastructure components to support IaC automation.  Specifically, it provisions:

- AWS OIDC provider and IAM role for GitHub Actions authentication
- AWS S3 buckets in each of 3 regions to support Terraform/Terragrunt IaC automation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.15.8 |
| aws | 6.51.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 6.51.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| tags | git::https://github.com/ulfiac/infra.git//terraform/modules/tags | main |
| tf\_state\_bucket\_ca\_central\_1 | ./modules/tf_state_bucket | n/a |
| tf\_state\_bucket\_us\_east\_1 | ./modules/tf_state_bucket | n/a |
| tf\_state\_bucket\_us\_east\_2 | ./modules/tf_state_bucket | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.oidc_gha](https://registry.terraform.io/providers/hashicorp/aws/6.51.0/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.oidc](https://registry.terraform.io/providers/hashicorp/aws/6.51.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachments_exclusive.oidc](https://registry.terraform.io/providers/hashicorp/aws/6.51.0/docs/resources/iam_role_policy_attachments_exclusive) | resource |
| [aws_iam_policy.admin_access](https://registry.terraform.io/providers/hashicorp/aws/6.51.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.billing](https://registry.terraform.io/providers/hashicorp/aws/6.51.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.assume_role_policy_oidc](https://registry.terraform.io/providers/hashicorp/aws/6.51.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| oidc\_role\_to\_assume | The name of the IAM role to be assumed by OIDC-auth'ed GitHub Actions. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
