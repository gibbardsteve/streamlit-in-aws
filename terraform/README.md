# Terraform

This terraform assumes that the AWS account has been bootstrapped with a domain in route 53.
You can bootstrap a domain using the repository [terraform-bootstrap]

The terraform then builds the necessary components to make a service running on Fargate accessible.
