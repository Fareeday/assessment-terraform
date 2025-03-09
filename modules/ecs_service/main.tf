# This Is Modules/Ecs_Service/Main.tf

resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = var.cluster_name
  task_definition = var.task_definition
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}


