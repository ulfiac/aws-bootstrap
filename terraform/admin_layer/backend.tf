terraform {
  backend "s3" {
    bucket       = "ulfiac-terraform-state"
    encrypt      = true
    key          = "aws-bootstrap/admin_layer/us-east-2/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
  }
}
