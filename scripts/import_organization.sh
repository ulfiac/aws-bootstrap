#!/bin/bash
set -euo pipefail

# Required environment variables:
#   AWS_ORGANIZATION_ID     - ID of the AWS Organization to import (e.g., o-xxxxxxxxxx)

# validate required environment variables exist
if [[ -z "${AWS_ORGANIZATION_ID:-}" ]]; then
  echo "Error: AWS_ORGANIZATION_ID environment variable is not set."
  exit 1
fi

# check versions
aws --version
terraform --version

# check if organization exists before importing
# if it does, import the resources
# if it does not, skip the import
# grep -q will return exit code 0 if the pattern is found, otherwise it returns 1
function import_organization() {
  if aws organizations describe-organization | grep -q "$AWS_ORGANIZATION_ID"; then
    echo -e "\n\nAWS Organization exists. Importing...\n\n"
    terraform import "module.organization[0].aws_organizations_organization.main" "$AWS_ORGANIZATION_ID"
  else
    echo -e "\n\nAWS Organization does not exist.  No import needed.\n\n"
  fi
}

# main
echo -e "\n\nStarting import of AWS organization resources into Terraform state...\n\n"

echo "::group::import AWS organization:"
import_organization
echo "::endgroup::"
