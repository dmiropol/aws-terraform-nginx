# aws-terraform-nginx
Sample script for deploying NGINX VM instance in AWS using Terraform

This script assumes that aws credentials already initialized and saved under ~/.aws/credentials file

Alternatively these varaiables can be exported as environment variables:
-   export TF_VAR_aws_access_key=xxxxxx
-   export TF_VAR_aws_secret_key=xxxxxx
-   export TF_VAR_aws_role_arn=xxxxxx
