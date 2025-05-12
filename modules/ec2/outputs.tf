output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = aws_instance.main[*].id
}

output "public_ips" {
  description = "List of public IPs for the instances"
  value       = aws_instance.main[*].public_ip
}
