#!/bin/bash
set -euo pipefail

# Required environment variables:
#   AWS_ORGANIZATION_ID                       - ID of the AWS Organization to import (e.g., o-xxxxxxxxxx)
#   AWS_ORGANIZATIONAL_UNIT_ID_WORKLOADS      - ID of the "workloads" organizational unit to import (e.g., ou-xxxxxxxxxx)
#   AWS_ORGANIZATIONAL_UNIT_ID_WORKLOADS_PROD - ID of the "workloads_prod" organizational unit to import (e.g., ou-xxxxxxxxxx)
#   AWS_ORGANIZATIONAL_UNIT_ID_WORKLOADS_TEST - ID of the "workloads_test" organizational unit to import (e.g., ou-xxxxxxxxxx)

# validate required environment variables exist
if [[ -z "${AWS_ORGANIZATION_ID:-}" ]]; then
  echo "Error: AWS_ORGANIZATION_ID environment variable is not set."
  exit 1
fi

if [[ -z "${AWS_ORGANIZATIONAL_UNIT_ID_WORKLOADS:-}" ]]; then
  echo "Error: AWS_ORGANIZATIONAL_UNIT_ID_WORKLOADS environment variable is not set."
  exit 1
fi

if [[ -z "${AWS_ORGANIZATIONAL_UNIT_ID_WORKLOADS_PROD:-}" ]]; then
  echo "Error: AWS_ORGANIZATIONAL_UNIT_ID_WORKLOADS_PROD environment variable is not set."
  exit 1
fi

if [[ -z "${AWS_ORGANIZATIONAL_UNIT_ID_WORKLOADS_TEST:-}" ]]; then
  echo "Error: AWS_ORGANIZATIONAL_UNIT_ID_WORKLOADS_TEST environment variable is not set."
  exit 1
fi


# check versions
aws --version
terraform --version
jq --version

# check if organization exists before importing
# if it does, import the resource
# if it does not, skip the import
function import_organization() {
  local org_id="$1"

  # call the AWS API to describe the organization; if it fails, the organization does not exist and no import is needed
  local org_description
  if ! org_description=$(aws organizations describe-organization --output json 2>/dev/null); then
    echo -e "\n\nAWS Organization does not exist.  No import needed.\n\n"
    return
  fi

  # parse the organization ID from the AWS response
  local actual_id
  actual_id=$(echo "$org_description" | jq -r '.Organization.Id')

  # validate we could parse the ID from the response
  if [[ -z "$actual_id" || "$actual_id" == "null" ]]; then
    echo -e "\n\nError: Could not parse Organization ID from AWS response.\n\n"
    exit 1
  fi

  # guard: ensure the returned ID matches the expected ID
  if [[ "$actual_id" != "$org_id" ]]; then
    echo -e "\n\nError: Organization returned ID '$actual_id' which does not match expected ID '$org_id'.\n\n"
    exit 1
  fi

  echo -e "\n\nAWS Organization exists. Importing...\n\n"
  terraform import "module.organization[0].aws_organizations_organization.main" "$org_id"
}

# check if organizational unit exists before importing
# if it does, import the resource
# if it does not, skip the import
function import_organizational_unit() {
  local ou_name="$1"
  local ou_id="$2"

  # describe the organizational unit to check if it exists and get its details
  local ou_description
  if ! ou_description=$(aws organizations describe-organizational-unit --organizational-unit-id "$ou_id" --output json 2>/dev/null); then
    echo -e "\n\nAWS Organizational Unit ID '$ou_id' does not exist.  No import needed.\n\n"
    return
  fi

  # parse the actual ID and name from the AWS response to validate they match expected values before importing
  local actual_id actual_name
  actual_id=$(echo "$ou_description" | jq -r '.OrganizationalUnit.Id')
  actual_name=$(echo "$ou_description" | jq -r '.OrganizationalUnit.Name')

  # validate we could parse the fields we need from the response
  if [[ -z "$actual_id" || "$actual_id" == "null" || -z "$actual_name" || "$actual_name" == "null" ]]; then
    echo -e "\n\nError: Could not parse Organizational Unit fields from AWS response.\n\n"
    exit 1
  fi

  # guard: ensure the returned OU ID matches the expected ID; if not, this is unexpected since the API call should have failed if the OU did not exist, so error out with details to help debug
  if [[ "$actual_id" != "$ou_id" ]]; then
    echo -e "\n\nError: Organizational Unit returned ID '$actual_id' which does not match expected ID '$ou_id'.\n\n"
    exit 1
  fi

  # guard: ensure the returned OU name matches the expected name; if not, this is likely a user error where the wrong OU ID was provided for import, so error out with details to help debug
  if [[ "$actual_name" != "$ou_name" ]]; then
    echo -e "\n\nError: Organizational Unit ID '$ou_id' exists but name '$actual_name' does not match expected name '$ou_name'.\n\n"
    exit 1
  fi

  echo -e "\n\nAWS Organizational Unit '$ou_name' exists. Importing...\n\n"
  terraform import "module.organization[0].aws_organizations_organizational_unit.${ou_name}" "$ou_id"
}


# main
echo -e "\n\nStarting import of AWS organization resources into Terraform state...\n\n"

echo "::group::import AWS organization:"
import_organization "$AWS_ORGANIZATION_ID"
echo "::endgroup::"

echo "::group::import AWS organization unit(workloads):"
import_organizational_unit "workloads" "$AWS_ORGANIZATIONAL_UNIT_ID_WORKLOADS"
echo "::endgroup::"

echo "::group::import AWS organization unit(workloads_prod):"
import_organizational_unit "workloads_prod" "$AWS_ORGANIZATIONAL_UNIT_ID_WORKLOADS_PROD"
echo "::endgroup::"

echo "::group::import AWS organization unit(workloads_test):"
import_organizational_unit "workloads_test" "$AWS_ORGANIZATIONAL_UNIT_ID_WORKLOADS_TEST"
echo "::endgroup::"
