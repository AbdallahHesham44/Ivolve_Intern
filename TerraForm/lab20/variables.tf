variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "existing_vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "subnets" {
  description = "Map of subnet configurations"
  type = map(object({
    cidr_block             = string
    map_public_ip_on_launch = bool
    tags                   = map(string)
  }))
  default = {
    "public" = {
      cidr_block             = "10.0.1.0/24"
      map_public_ip_on_launch = true
      tags = {
        Name = "public-subnet"
      }
    }
    "private" = {
      cidr_block             = "10.0.2.0/24"
      map_public_ip_on_launch = false
      tags = {
        Name = "private-subnet"
      }
    }
  }
}


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "nat_gateway_id" {
  description = "Existing NAT Gateway ID for import"
  type        = string
  default     = null
}
