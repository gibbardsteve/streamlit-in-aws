terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_ecs_cluster" "ecs_tf_cluster" {
  name = "ecs-tf-cluster"
}


resource "aws_ecs_cluster_capacity_providers" "ecs_tf_cap_prov" {
  cluster_name = aws_ecs_cluster.ecs_tf_cluster.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]


}

# Required for task execution to ensure logs are created in CloudWatch
resource "aws_cloudwatch_log_group" "ecs-tf-streamlit-app-task-def" {
  name = "/ecs/ecs-tf-streamlit-app-task-def"
}

resource "aws_ecs_task_definition" "ecs_tf_task_def" {
  family = "ecs-tf-streamlit-app-task-def"
  container_definitions = jsonencode([
    {
      name      = "tf-streamlit-app"
      image     = "${var.aws_account_id}.dkr.ecr.eu-west-2.amazonaws.com/streamlit-demo:latest"
      cpu       = 0,
      essential = true
      portMappings = [
        {
          name          = "streamlit-8501-tcp",
          containerPort = 8501,
          hostPort      = 8501,
          protocol      = "tcp",
          appProtocol   = "http"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/ecs-tf-streamlit-app-task-def",
          "awslogs-region"        = "eu-west-2",
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
  execution_role_arn       = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "3072"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

}

resource "aws_security_group" "allow_tf_streamlit" {
  name        = "allow_tf_streamlit"
  description = "Allow inbound traffic on port 8501"
  /*vpc_id      = data.aws_vpc.main.id*/

  ingress {
    from_port   = 8501
    to_port     = 8501
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
