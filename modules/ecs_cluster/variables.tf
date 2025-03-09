# This Is Modules/Ecs_Cluster/Variables.tf

variable "cluster_name"  {
  description = "Name of The ECS Cluster"
  type        = string
}

variable "container_name"  {
  description = "Name of The ECS Cluster"
  type        = string
}

variable "image_name"  {
  description = "Name of The ECS Cluster"
  type        = string
}

variable  "iam_role_arn"  {
  description = "IAM Role ARN for ECS Task Execution"
  type        = string
}
