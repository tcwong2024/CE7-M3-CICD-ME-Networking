variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name of VPC to use"
  type        = string
  default     = "ce7-grp-2-wtc-tf-vpc"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_prefix" {
  description = "The prefix for the public subnet name"
  type        = string
  default     = "ce7-grp-2-wtc-public"
}

variable "private_subnet_prefix" {
  description = "The prefix for the private subnet name"
  type        = string
  default     = "ce7-grp-2-wtc-private"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "internet_gateway" {
  type    = string
  default = "ce7-grp-2-wtc-igw"
}

variable "vpc_endpoint_s3" {
  type    = string
  default = "ce7-grp-2-wtc-vpce-s3"
}

variable "public_rt" {
  type    = string
  default = "ce7-grp-2-wtc-public-rt"
}

variable "private_rt" {
  type    = string
  default = "ce7-grp-2-wtc-private-rt"
}