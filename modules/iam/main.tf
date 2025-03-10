# This Is Modules/IAM/Main.tf
# IAM Role For ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAM Role For S3 Replication
resource "aws_iam_role" "s3_replication_role" {
  name = "S3ReplicationRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_replication_policy" {
  name        = "S3ReplicationPolicy"
  description = "Policy to allow S3 cross-region replication"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.source_bucket}",
          "arn:aws:s3:::${var.source_bucket}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = [
          "arn:aws:s3:::${var.destination_bucket}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication_attachment" {
  role       = aws_iam_role.s3_replication_role.name
  policy_arn = aws_iam_policy.s3_replication_policy.arn
}

resource "aws_iam_policy" "s3_admin_policy" {
  name        = "S3AdminPolicy"
  description = "Allows full access to manage S3 bucket policies"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:PutBucketPolicy",
          "s3:GetBucketPolicy",
          "s3:DeleteBucketPolicy",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetObject"
        ],
        Resource = [
          "arn:aws:s3:::my-s0urc3-buck3t",
          "arn:aws:s3:::my-s0urc3-buck3t/*",
          "arn:aws:s3:::my-d3st1nat1on-buck3t",
          "arn:aws:s3:::my-d3st1nat1on-buck3t/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_admin_attach" {
  role       = aws_iam_role.s3_replication_role.name
  policy_arn = aws_iam_policy.s3_admin_policy.arn
}

