terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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
  name              = "/ecs/ecs-tf-streamlit-app-task-def"
  retention_in_days = var.log_retention_days
}

resource "aws_ecs_task_definition" "ecs_tf_task_def" {
  family = "ecs-tf-streamlit-app-task-def"
  container_definitions = jsonencode([
    {
      name      = "tf-streamlit-app"
      image     = "${var.aws_account_id}.dkr.ecr.eu-west-2.amazonaws.com/${var.container_image}:${var.container_tag}"
      cpu       = 0,
      essential = true
      portMappings = [
        {
          name          = "streamlit-${var.container_port}-tcp",
          containerPort = var.container_port,
          hostPort      = var.container_port,
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
  description = "Allow inbound traffic on port ${var.container_port} from ${var.from_port}"

  ingress {
    from_port   = var.from_port
    to_port     = var.container_port
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

resource "aws_ecs_service" "ecs-service-streamlit-app" {
  name             = "ecs-service-streamlit-app"
  cluster          = aws_ecs_cluster.ecs_tf_cluster.id
  task_definition  = aws_ecs_task_definition.ecs_tf_task_def.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  enable_ecs_managed_tags = true # It will tag the network interface with service name
  wait_for_steady_state   = true # Terraform will wait for the service to reach a steady state before continuing

  load_balancer {
    target_group_arn = aws_lb_target_group.ip_example.arn
    container_name   = "tf-streamlit-app"
    container_port   = var.container_port
  }

  # We need to wait until the target group is attached to the listener
  # and also the load balancer so we wait until the listener creation
  # is complete first
  depends_on = [aws_alb_listener.app_http]
  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.allow_tf_streamlit.id]
    assign_public_ip = true
  }

}

