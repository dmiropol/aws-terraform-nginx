#!/bin/bash
terraform init

rm tfplan
rm tfdestroy
rm terraform.tfstate*

terraform plan -out=tfplan
terraform apply --auto-approve tfplan 

