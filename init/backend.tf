terraform {
  backend "s3" {
    bucket       = "ulfiac-terraform-state"
    encrypt      = true
    key          = "aws-init/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
  }
}
