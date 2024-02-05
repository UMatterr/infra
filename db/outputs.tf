output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.master.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.master.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.master.username
  sensitive   = true
}

output "rds_replica_connection_parameters" {
  description = "RDS replica instance connection parameters"
  value       = "-h ${aws_db_instance.replica.address} -p ${aws_db_instance.replica.port} -U ${aws_db_instance.replica.username} postgres"
}
