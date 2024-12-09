variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "us-east-1a"
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "dev"
}

variable "alert_email" {
  description = "Email address for SNS notifications"
  type        = string
}

variable "flow_log_retention_days" {
  description = "Number of days to retain VPC flow logs"
  type        = number
  default     = 30
}

variable "alarm_threshold" {
  description = "Threshold for CloudWatch alarm"
  type        = number
  default     = 100
}

variable "vpc_tags" {
  description = "Tags for VPC resources"
  type        = map(string)
  default     = {}
}


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  # Amazon Linux 2023 AMI ID for us-east-1
  default     = "ami-0230bd60aa48260c6"
}