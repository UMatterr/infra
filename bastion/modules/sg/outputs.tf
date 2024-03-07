output "sg_id" {
  description = "The security group id"
  value       = aws_security_group.my_security_group.id
}
