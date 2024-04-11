# Get the AWS account ID
data "aws_caller_identity" "current" {}
data "aws_vpc" "main" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}


data "aws_network_interface" "interface_tags" {
  depends_on = [aws_ecs_service.ecs-service-streamlit-app]
  filter {
    name   = "tag:aws:ecs:serviceName"
    values = ["ecs-service-streamlit-app"]
  }
}

