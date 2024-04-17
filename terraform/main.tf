resource "aws_ecs_cluster" "service_cluster" {
  name = "service-cluster"
}


resource "aws_ecs_cluster_capacity_providers" "service_providers" {
  cluster_name = aws_ecs_cluster.service_cluster.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]


}

# Required for task execution to ensure logs are created in CloudWatch
resource "aws_cloudwatch_log_group" "ecs_service_logs" {
  name              = "/ecs/ecs-service-${var.app_name}-application"
  retention_in_days = var.log_retention_days
}

resource "aws_ecs_task_definition" "ecs_service_definition" {
  family = "ecs-service-${var.app_name}-application"
  container_definitions = jsonencode([
    {
      name      = "${var.app_name}-task-application"
      image     = "${var.aws_account_id}.dkr.ecr.eu-west-2.amazonaws.com/${var.container_image}:${var.container_tag}"
      cpu       = 0,
      essential = true
      portMappings = [
        {
          name          = "${var.app_name}-${var.container_port}-tcp",
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
          "awslogs-group"         = "/ecs/ecs-service-${var.app_name}-application",
          "awslogs-region"        = "eu-west-2",
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
  execution_role_arn       = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.service_cpu
  memory                   = var.service_memory
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

}

resource "aws_ecs_service" "application" {
  name             = "${var.app_name}-service"
  cluster          = aws_ecs_cluster.service_cluster.id
  task_definition  = aws_ecs_task_definition.ecs_service_definition.arn
  desired_count    = var.task_count
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  enable_ecs_managed_tags = true # It will tag the network interface with service name
  wait_for_steady_state   = true # Terraform will wait for the service to reach a steady state before continuing

  load_balancer {
    target_group_arn = aws_lb_target_group.fargate_tg.arn
    container_name   = "${var.app_name}-task-application"
    container_port   = var.container_port
  }

  # We need to wait until the target group is attached to the listener
  # and also the load balancer so we wait until the listener creation
  # is complete first
  depends_on = [aws_alb_listener.app_http]
  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.allow_rules_service.id]
    assign_public_ip = true
  }

}

