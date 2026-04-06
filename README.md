# aws-bootstrap

Bootstraps a new AWS account with the foundational Terraform infrastructure required to manage the rest of the `ulfiac` estate. Specifically, it provisions:

- **GitHub Actions OIDC provider** — enables keyless authentication from GitHub Actions workflows
- **OIDC IAM role** — grants `AdministratorAccess` and `Billing` to workflows in the `ulfiac/aws-bootstrap` and `ulfiac/infra` repositories
- **Terraform state S3 buckets** — one bucket per region (`us-east-2`, `us-east-1`, `ca-central-1`) used as remote backends across the estate

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

### 2. Create a Temporary Root User Access Key

> **Security note:** This key is used only to run the initial `apply`. Delete it immediately after step 5 below.

1. Open the root user menu (top-right) → **Security credentials**
2. Under **Access keys**, choose **Create access key**
3. Copy the **Access Key ID** and **Secret Access Key**

### 3. Configure the GitHub Environment

In the `aws-bootstrap` repository on GitHub, create an environment that matches the `aws_environment` workflow input (e.g. `aws_mgmt`) and add:

**Secrets**

| Name | Value |
|------|-------|
| `AWS_ACCESS_KEY_ID` | Root user access key ID from step 2 |
| `AWS_SECRET_ACCESS_KEY` | Root user secret access key from step 2 |
| `AWS_ACCOUNT_ID` | 12-digit AWS account ID |

**Variables**

| Name | Value |
|------|-------|
| `OIDC_ROLE_TO_ASSUME` | Name to give the IAM role (e.g. `gha-oidc`) |

### 4. Run the Deploy Workflow

Run the **deploy** workflow (`deploy.yaml`) from the GitHub Actions UI:

1. **Auth:** `keys` · **Action:** `plan` — review the plan output
2. **Auth:** `keys` · **Action:** `apply` — apply the changes
3. **Auth:** `oidc` · **Action:** `plan` — verify OIDC auth works (plan should show no changes)

### 5. Delete the Root User Access Key

Return to **Security credentials** in the AWS Console and delete the access key created in step 2. All future deployments use the OIDC role.

## Repository Structure

```
terraform/
├── main.tf                  # Locals (OIDC provider hostname)
├── iam_oidc_provider.tf     # GitHub Actions OIDC provider
├── iam_role.tf              # OIDC IAM role + policy attachments
├── tf_state_buckets.tf      # Remote state S3 buckets (multi-region)
├── variables.tf             # Input variables
└── modules/
    ├── organization/        # AWS Organizations configuration
    └── tf_state_bucket/     # Reusable S3 state bucket module
.github/workflows/
├── deploy.yaml              # Main dispatch workflow (plan / apply / destroy)
└── reusable_terraform_action.yaml
```

## Contributing

Open a pull request against `main`. The `linter` workflow runs automatically on the PR.

## License

See [LICENSE](LICENSE).
