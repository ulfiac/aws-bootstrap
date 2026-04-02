resource "aws_organizations_organizational_unit" "workloads" {
  name      = "workloads"
  parent_id = aws_organizations_organization.main.roots[0].id

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_organizations_organizational_unit" "workloads_prod" {
  name      = "workloads_prod"
  parent_id = aws_organizations_organizational_unit.workloads.id

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_organizations_organizational_unit" "workloads_test" {
  name      = "workloads_test"
  parent_id = aws_organizations_organizational_unit.workloads.id

  lifecycle {
    prevent_destroy = true
  }
}
