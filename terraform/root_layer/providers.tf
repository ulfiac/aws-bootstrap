provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      created_by = "terraform"
      project    = "ulfiac root layer"
    }
  }
}
