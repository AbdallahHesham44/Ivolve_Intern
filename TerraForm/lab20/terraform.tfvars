aws_region = "us-east-1"
existing_vpc_id = "vpc-02c1bd0e833451f82" 
subnets = {
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

instance_type = "t2.micro"
key_name = "firstKey_Ansible"
