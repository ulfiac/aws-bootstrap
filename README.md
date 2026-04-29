# aws-bootstrap

Bootstrap a new AWS account with the bare minimum required to enable IaC.  Specifically, this repo has two high-level objectives:

1. enable GitHub Actions workflow authentication via OIDC
2. create S3 buckets for remote terraform state used by other IaC repos

## Key design decisions
1. assume a brand new AWS account with nothing created/configured yet
2. first execution will use temporary root user access keys to auth; subsequent executions will auth without keys via OIDC
3. only do the bare minimum to accomplish the stated objectives above, nothing more
4. use terraform
5. dynamically import each resource into a local terraform state during bootstrap

## Usage

### Manual initial setup
- [create an aws account](https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-creating.html) - requires unique email, choose paid plan, can use same payment details.  Upon completion you're logged into the AWS Console as the root user.
- [enable the cost explorer](https://docs.aws.amazon.com/cost-management/latest/userguide/ce-enable.html) - this must be done manually by the root user via the AWS Console. It cannot be done via the AWS CLI or API.
- [grant access to the billing console](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started-account-iam.html) - IAM users and roles in an AWS account can't access the Billing and Cost Management console by default. This is true even if they have IAM policies that grant access to certain Billing features. To grant access, the AWS account root user must first activate IAM access. This must be done manually by the root user via the AWS Console. It cannot be done via the AWS CLI or API.
- [enable a virtual MFA device on the root user](https://docs.aws.amazon.com/IAM/latest/UserGuide/enable-virt-mfa-for-root.html) - this should be done manually by the root user via the AWS Console.
- [create an access key on the root user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user_manage_add-key.html) - this should be done manually by the root user via the AWS Console.  This key is used only to run the first terraform `apply`. Delete it immediately after the first terraform run completes successfully (once OIDC is properly configured).  Meaning, follow the clean-up instructions below.
- [create a GitHub environment](https://docs.github.com/en/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments) - should be in the format `aws_<account_name>` where `<account_name>` matches the account name chosen when creating an AWS account above.
- [create GitHub environment secrets](https://docs.github.com/en/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments) - create the following environment secrets:
  - `AWS_ACCOUNT_ID` - 12-digit aws account number
  - `AWS_ACCESS_KEY_ID` - root user access key ID from above
  - `AWS_SECRET_ACCESS_KEY` - root user secret access key from above
- [create GitHub environment variables](https://docs.github.com/en/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments) - create the following environment variables:
  - `OIDC_ROLE_TO_ASSUME` - name of the IAM role that OIDC will assume
- [edit the deploy workflow](https://github.com/ulfiac/aws-bootstrap/blob/main/.github/workflows/deploy.yaml#L15) - add the new environment name as an option on "workflow_dispatch" for the input named "aws_environment".
- [edit the reusable_terraform_action workflow](https://github.com/ulfiac/aws-bootstrap/blob/main/.github/workflows/reusable_terraform_action.yaml#L31) - add the new environment name as an option on "workflow_dispatch" for the input named "aws_environment".

### Run the workflow
- [run the deploy workflow (1st time)](https://github.com/ulfiac/aws-bootstrap/actions/workflows/deploy.yaml) - auth=keys; action=plan — review the plan output
- [run the deploy workflow (2nd time)](https://github.com/ulfiac/aws-bootstrap/actions/workflows/deploy.yaml) - auth=keys; action=apply — apply the changes
- [run the deploy workflow (3rd time)](https://github.com/ulfiac/aws-bootstrap/actions/workflows/deploy.yaml) - auth=oidc; action=plan — verify OIDC auth works and the plan shows no changes

### Manual clean-up
- [delete the access key on the root user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user_manage_delete-key.html) - delete the access key created above on the root user.  All future deployments will use the OIDC authentication.
- [delete GitHub environment secrets](https://docs.github.com/en/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments) - delete the following environment secrets:
  - `AWS_ACCESS_KEY_ID` - root user access key ID from above
  - `AWS_SECRET_ACCESS_KEY` - root user secret access key from above

## Contributing
Contributions are not being accepted at this time.

## License
See [LICENSE](LICENSE).

## References
- https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/control-access-billing.html
- https://repost.aws/knowledge-center/iam-billing-access
