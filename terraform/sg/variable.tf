# VPC ID
variable "vpc_id" {
  description = "The VPC ID to create the security group in"
  type        = string
}

# Security group
variable "sg_name" {
  description = "The security group name"
  type        = string
  default     = "ce7-grp-2-wtc-sg"
}

# Default security group
variable "default_sg_name" {
  description = "The default security group name"
  type        = string
  default     = "ce7-grp-2-wtc-def-sg"
}
