provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      created_by = "terraform"
      project    = "ulfiac init"
    }
  }
}
