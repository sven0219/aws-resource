provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket = "sven-terraform-state"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
  }
}


