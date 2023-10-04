# Setup provider for region
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "resume-as-code-aws-cicd-pipeline"
    encrypt = true
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}
