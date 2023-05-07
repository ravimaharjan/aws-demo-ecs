variable "env" {
  type        = string
  description = "name of the env i.e. dev/prod/uat/test"
}

variable "region" {
  type        = string
  description = "region"
  default     = "ap-southeast-2"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "list of cidr blocks to create public subnet with"
}

variable "vpc_cidr_block" {
  type        = string
  description = "cidr block to create vpc with"
}

/* ECS setup*/

variable "cluster_name" {
  type        = string
  description = "name of the cluster"
}

variable "service_name" {
  type        = string
  description = "name of the ecs service"
}

variable "app_name" {
  type        = string
  description = "name of the application running in the container"
}

variable "app_image" {
  type        = string
  description = "docker image"
}

variable "app_port" {
  type        = number
  description = "application port to run"
}

variable "container_port" {
  type        = number
  description = "container port to run"
}

variable "container_count" {
  type        = string
  description = "number of container instances to run"
}

variable "fargate_cpu" {
  type        = number
  description = "CPU of the container"
}

variable "fargate_memory" {
  type        = number
  description = "memory of the container"
}

variable "health_check_path" {
  type = string
}

variable "ecs_task_execution_role" {
  type        = string
  description = "IAM role for the ECS Task"
}
