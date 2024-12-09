output "public_instance_ips" {
  value = {
    for idx, instance in aws_instance.public : 
    "public-instance-${idx + 1}" => {
      public_ip  = instance.public_ip
      private_ip = instance.private_ip
    }
  }
}

output "private_instance_ips" {
  value = {
    for idx, instance in aws_instance.private :
    "private-instance-${idx + 1}" => {
      private_ip = instance.private_ip
    }
  }
}
