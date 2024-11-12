# Security Group for VPC Allow 80(HTTP), 443(HTTPS) and 22 (SSH)
resource "aws_security_group" "sg" {
  name        = var.sg_name
  description = "Security group for EC2 instances"
  vpc_id      = var.vpc_id

  # Port 80 for HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Port 80 for HTTPSyes
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Port 80 for SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # "-1" Allows all protocols
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.sg_name
  }

  #checkov:skip=CKV_AWS_260: Ensure no security groups allow ingress from 0.0.0.0:0 to port 80
  #checkov:skip=CKV_AWS_24: Ensure no security groups allow ingress from 0.0.0.0:0 to port 22
  #checkov:skip=CKV_AWS_23: Ensure every security group and rule has a description
  #checkov:skip=CKV2_AWS_5: Ensure that Security Groups are attached to another resource
  #checkov:skip=CKV2_AWS_11: Ensure VPC flow logging is enabled in all VPCs
}

# Manage the default security group for the VPC
resource "aws_default_security_group" "default" {
  vpc_id = var.vpc_id

  # ingress {
  #   protocol   = "-1"    # -1 means all protocols
  #   self       = true    # allows inbound traffic from instances associated with the same security group
  #   from_port  = 0
  #   to_port    = 0
  # }

  # egress {
  #   protocol   = "-1"    # all protocols
  #   from_port  = 0
  #   to_port    = 0
  #   cidr_blocks = ["0.0.0.0/0"]  # allows all outbound traffic
  # }

  tags = {
    Name    = var.default_sg_name
    Default = "True"
  }
}
