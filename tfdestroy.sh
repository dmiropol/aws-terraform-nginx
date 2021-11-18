#!/bin/bash
terraform plan -destroy -out=tfdestroy
terraform apply --auto-approve  tfdestroy
