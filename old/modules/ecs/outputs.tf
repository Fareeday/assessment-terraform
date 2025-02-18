/*output "ecs_cluster_east_1_name" {
  value = module.ecs_cluster_east_1.ecs_cluster_name
}

output "ecs_service_east_1_name" {
  value = module.ecs_cluster_east_1.ecs_service_name
}

output "ecs_cluster_west_2_name" {
  value = module.ecs_cluster_west_2.ecs_cluster_name
}

output "ecs_service_west_2_name" {
  value = module.ecs_cluster_west_2.ecs_service_name
}*/


output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  value = aws_ecs_cluster.this.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}

output  "container_name"  {
  value = var.container_name
}
