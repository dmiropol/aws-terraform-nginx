terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.65.0"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
  required_version = ">= 0.13"
}

/*
Assuming that aws credentials initialized and save under ~/.aws/credentials file
Alternatively these varaiables can be exported as environment variables:
  #export TF_VAR_aws_access_key=xxxxxx
  #export TF_VAR_aws_secret_key=xxxxxx
  #export TF_VAR_aws_role_arn=xxxxxx
*/

provider "aws" {
  region = var.aws_provider.aws_region
  shared_credentials_file = var.aws_provider.aws_credentials
  profile                 = var.aws_provider.aws_profile
}
