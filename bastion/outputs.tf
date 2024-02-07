output "key" {
  description = "the value of key pair to access bastion"
  sensitive   = true
  value       = aws_key_pair.key
}
