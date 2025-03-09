# This Is Modules/VPC/Outputs.tf
output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  value = length(aws_nat_gateway.this) > 0 ? aws_nat_gateway.this[0].id : null
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}

