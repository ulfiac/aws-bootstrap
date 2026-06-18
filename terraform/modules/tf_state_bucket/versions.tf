terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.51.0" # current as of 2026-06-18
    }
  }
  required_version = ">= 1.15.6" # current as of 2026-06-18
}
