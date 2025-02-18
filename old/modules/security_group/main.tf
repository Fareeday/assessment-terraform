resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  tags = {
    Name = var.security_group_name
  }
}

# Allow inbound MySQL/Aurora traffic on port 3306
resource "aws_security_group_rule" "rds_inbound" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
}

# Inbound Rules
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.this.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.this.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

# Outbound Rules (Allow all outbound traffic)
resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.this.id

  cidr_ipv4   = "0.0.0.0/0" # Allow outbound traffic to anywhere
  ip_protocol = "-1"        # Allow all protocols
}
