env    = "dev"
region = "ap-southeast-2"

public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]


vpc_cidr_block = "10.0.0.0/16"
cluster_name   = "ecs-cluster"

service_name            = "ecs-service"
app_name                = "ExpressApp"
app_image               = "url to the ecr image"
app_port                = 5000
container_port          = 5000
fargate_cpu             = 512
fargate_memory          = 1024
container_count         = "1"
health_check_path       = "/"
ecs_task_execution_role = "ecs_task_execution_role"
