# Get the AWS account ID
data "aws_caller_identity" "current" {}

data "aws_vpc" "main" {
  default = true
}