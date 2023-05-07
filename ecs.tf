resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

# data "template_file" "app" {
#   template = file("./container-definition/container.json")

#   vars = {
#     app_name       = var.app_name
#     app_image      = var.app_image
#     app_port       = var.app_port
#     fargate_cpu    = var.fargate_cpu
#     fargate_memory = var.fargate_memory
#     aws_region     = var.region
#   }
# }

resource "aws_ecs_task_definition" "task" {
  family                   = "ExpressApp"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  #   container_definitions    = data.template_file.app
  container_definitions = jsonencode([
    {
      name         = var.app_name
      image        = var.app_image
      cpu          = var.fargate_cpu
      memory       = var.fargate_memory
      network_mode = "awsvpc"
      essential    = true
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-create-group  = "true",
          awslogs-group         = "demo-ecs-log-reactapp",
          awslogs-region        = var.region
          awslogs-stream-prefix = "awslogs-example"
        }
      },
    },
  ])
}

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.container_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.sg-container.id]
    subnets          = aws_subnet.public.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.myapp-tg.arn
    container_name   = var.app_name
    container_port   = var.app_port
  }

  #   depends_on = [aws_alb_listener.testapp, aws_iam_role_policy_attachment.ecs_task_execution_role]
}
