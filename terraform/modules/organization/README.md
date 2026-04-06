# aws organization

Terraform module to create aws organization.

## Usage Instructions

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.1 |
| aws | >= 6.24.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 6.24.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_organizations_organization.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) | resource |
| [aws_organizations_organizational_unit.workloads](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_organizational_unit.workloads_prod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_organizational_unit.workloads_test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Contributing

## License

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
