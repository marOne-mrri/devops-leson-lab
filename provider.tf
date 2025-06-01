provider "aws" {
  region = "eu-west-3"
}

terraform {
  backend "s3" {
    region  = "eu-north-1"
    bucket  = "tf-backend-state-s3-lab-env"
    key     = "lab"
    encrypt = true
  }
}
