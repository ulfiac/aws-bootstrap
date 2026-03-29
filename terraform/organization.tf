module "organization" {
  count  = var.aws_environment == "aws_mgmt" ? 1 : 0
  source = "./modules/organization"

  providers = {
    aws = aws
  }
}
