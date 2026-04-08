# aws-bootstrap

Bootstraps various AWS accounts with the foundational Terraform infrastructure required to manage them with IaC. Specifically, it provisions:

- **GitHub Actions OIDC provider** — enables keyless authentication from GitHub Actions workflows
- **OIDC IAM role** — grants `AdministratorAccess` and `Billing` to workflows in the `ulfiac/aws-bootstrap` and `ulfiac/infra` repositories
- **Terraform state S3 buckets** — one bucket per region (`us-east-2`, `us-east-1`, `ca-central-1`) used as remote backends by the terraform/terragrunt in the `ulfiac/infra` repository

Because this module is itself the thing that creates the OIDC trust, it must be bootstrapped once using temporary root user access keys before it can use keyless auth thereafter.

## Prerequisites

- AWS root user access (a freshly created account, or an existing one)
- A GitHub environment named for the target AWS account (e.g. `aws_mgmt`) in this repository

## Bootstrap Procedure

### 1. Create an AWS Account

Complete the sign-up flow at [aws.amazon.com](https://aws.amazon.com):

| Step | Action |
|------|--------|
| 1 | Enter email & account name; verify email; set password; choose a paid plan |
| 2 | Enter contact information; accept the AWS Customer Agreement |
| 3 | Enter billing information |
| 4 | Identity verification |
| 5 | Select a support plan — **Basic (free)** is sufficient |

After sign-up you are logged into the AWS Console as the root user.

### 2. Enable Cost Explorer

You can enable Cost Explorer for your account by opening Cost Explorer for the first time in the AWS Cost Management console. You can't enable Cost Explorer using the API.

This must be done manually by the root user via the AWS Console. It cannot be done via the AWS CLI or API.

step-by-step:
https://docs.aws.amazon.com/cost-management/latest/userguide/ce-enable.html

### 3. Grant access to the billing console

IAM users and roles in an AWS account can't access the Billing and Cost Management console by default. This is true even if they have IAM policies that grant access to certain Billing features. To grant access, the AWS account root user must first activate IAM access.

This must be done manually by the root user via the AWS Console. It cannot be done via the AWS CLI or API.

step-by-step:
https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started-account-iam.html

reference:
https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/control-access-billing.html
https://repost.aws/knowledge-center/iam-billing-access

### 4. Enable a virtual MFA device for the root user

This should be done manually by the root user via the AWS Console.

step-by-step:
https://docs.aws.amazon.com/IAM/latest/UserGuide/enable-virt-mfa-for-root.html

### 5. Create an access key on the root user (temporary)

> **Security note:** This key is used only to run the first terraform `apply`. Delete it immediately after the first terraform run completes successfully (once OIDC is properly configured).

This should be done manually by the root user via the AWS Console.

step-by-step:
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user_manage_add-key.html

### 6. Create the GitHub Environment

Create an environment in this GitHub repo in the format `aws_< account name >` (e.g. `aws_mgmt`), where <account_name> matches the account name chosen while creating the AWS account above.  Add the following Environment secrets and Environment variables:

**Secrets**

| Name | Value |
|------|-------|
| `AWS_ACCOUNT_ID` | 12-digit AWS account ID |
| `AWS_ACCESS_KEY_ID` | Root user access key ID from step 2 |
| `AWS_SECRET_ACCESS_KEY` | Root user secret access key from step 2 |

**Variables**

| Name | Value |
|------|-------|
| `OIDC_ROLE_TO_ASSUME` | Name to give the IAM role (e.g. `gha-oidc`) |

### 7. Add the new environment name to the GitHub Actions workflow inputs

Edit the code for the workflows listed below.  Add the new environment name as an option on `workflow_dispatch` for the input variable named `aws_environment`.

`deploy`
`reusable_terraform_action`

### 8. Run the Deploy Workflow

Run the **deploy** workflow (`deploy.yaml`) from the GitHub Actions UI:

1. **Auth:** `keys` · **Action:** `plan` — review the plan output
2. **Auth:** `keys` · **Action:** `apply` — apply the changes
3. **Auth:** `oidc` · **Action:** `plan` — verify OIDC auth works (plan should show no changes)

### 9. Delete the access key on the Root User

Return to **Security credentials** in the AWS Console and delete the root user access key created in step 5. All future deployments will use the OIDC role.

### 10. Delete the environment secrets

Delete the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` secrets from the environment created in step 6.

## Repository Structure

```
terraform/
├── main.tf                  # Locals (OIDC provider hostname)
├── iam_oidc_provider.tf     # GitHub Actions OIDC provider
├── iam_role.tf              # OIDC IAM role + policy attachments
├── tf_state_buckets.tf      # Remote state S3 buckets (multi-region)
├── variables.tf             # Input variables
└── modules/
    └── tf_state_bucket/     # Reusable S3 state bucket module
.github/workflows/
├── deploy.yaml              # Main dispatch workflow (plan / apply / destroy)
└── reusable_terraform_action.yaml
```

## Contributing

Open a pull request against the `main` branch. The `linter` workflow runs automatically on the PR.

## License

See [LICENSE](LICENSE).
