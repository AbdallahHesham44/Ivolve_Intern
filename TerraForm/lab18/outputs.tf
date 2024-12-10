output "instance_private_ips" {
  description = "Private IPs of the EC2 instances"
  value       = module.ec2_instance[*].private_ip
}

output "instance_public_ips" {
  description = "Public IPs of the EC2 instances"
  value       = module.ec2_instance[*].public_ip
}
