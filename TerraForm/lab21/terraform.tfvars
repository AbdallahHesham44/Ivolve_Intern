aws_region            = "us-east-1"
vpc_cidr              = "10.0.0.0/16"
public_subnet_cidr    = "10.0.1.0/24"
availability_zone     = "us-east-1a"
environment           = "dev"
alert_email          = "abdallah.hesham.102@gmail.com"
flow_log_retention_days = 30
alarm_threshold       = 100
instance_type = "t2.micro"
ami_id        = "ami-0e2c8caa4b6378d8c"  

vpc_tags = {
  Environment = "dev"
  Project     = "vpc-setup"
  Terraform   = "true"
  Owner       = "abdallah"
}
