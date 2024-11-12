# Show public vpc name
# -------------------------------

output "vpc_name" {
  description = "The name of the VPC"
  value       = aws_vpc.main.tags["Name"]
}

# Show public subnet id and name
# -------------------------------

output "public_subnets_info" {
  description = "IDs and names of the public subnets"
  value = [
    for i in range(length(aws_subnet.public)) : {
      id   = aws_subnet.public[i].id
      name = aws_subnet.public[i].tags["Name"]
    }
  ]
}

# Show private subnet id and name
# -------------------------------

output "private_subnets_info" {
  description = "IDs and names of the private subnets"
  value = [
    for i in range(length(aws_subnet.private)) : {
      id   = aws_subnet.private[i].id
      name = aws_subnet.private[i].tags["Name"]
    }
  ]
}

# Show internet gateway
# -------------------------------
output "internet_gateway_info" {
  description = "ID and Names of the internet gateway"

  value = {
    id   = aws_internet_gateway.igw.id
    name = aws_internet_gateway.igw[*].tags["Name"]
  }
}

# Show s3 endpoint
# -------------------------------
output "s3_endpoint_info" {
  description = "ID and Names of s3_endpoint"

  value = {
    id   = aws_vpc_endpoint.vpce_s3.id
    name = aws_vpc_endpoint.vpce_s3[*].tags["Name"]
  }
}