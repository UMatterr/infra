output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "vpc_name" {
  value = aws_vpc.my_vpc.tags["Name"]
}

output "subnet_ids" {
  value = aws_subnet.my_subnets.*.id
}
