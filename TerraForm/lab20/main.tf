provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "existing" {
  id = var.existing_vpc_id
}

# VPC
resource "aws_vpc" "main" {
  # These values should match your existing VPC configuration
  cidr_block           = data.aws_vpc.existing.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_subnet" "subnets" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block             = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  availability_zone       = "${var.aws_region}a"
  tags                   = each.value.tags
}


# NAT Gateway
resource "aws_nat_gateway" "main" {
  connectivity_type = "public"
  subnet_id         = aws_subnet.subnets["public"].id
  allocation_id = aws_eip.nat_eip.id 
  tags = {
    Name = "main-nat-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [aws_internet_gateway.main]
}


# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "private-rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public" {
 subnet_id      = aws_subnet.subnets["public"].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.subnets["private"].id
  route_table_id = aws_route_table.private.id
}
# Security Groups
resource "aws_security_group" "public" {
  name        = "public-sg"
  description = "Security group for public instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_eip" "nat_eip" {
  domain = "vpc"  # Use 'vpc' domain for EC2-VPC

  tags = {
    Name = "nat-gateway-eip"
  }

  # To ensure proper ordering
  depends_on = [aws_internet_gateway.main]
}

resource "aws_security_group" "private" {
  name        = "private-sg"
  description = "Security group for private instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instances
resource "aws_instance" "public" {
  count                  = 1
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnets["public"].id
  vpc_security_group_ids = [aws_security_group.public.id]
  key_name              = var.key_name
  associate_public_ip_address = true
    user_data = <<-EOF
              #!/bin/bash
              set -e
              echo 'Starting user data script...'
              sudo yum update -y
              sudo yum install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo 'Welcome nginx sdadsa' > sudo tee /usr/share/nginx/html/index.html
              echo 'User data script complete'
              EOF

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${var.key_name}.pem")
      host        = self.public_ip
      timeout     = "5m"
    }

  tags = {
    Name = "public-instance-${count.index + 1}"
  }
}

resource "aws_instance" "private" {
  count                  = 1
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
 subnet_id              = aws_subnet.subnets["private"].id
  vpc_security_group_ids = [aws_security_group.private.id]
  key_name              = var.key_name
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo 'Welcome apache sdadsa' > /var/www/html/index.html
              EOF

  tags = {
    Name = "private-instance-${count.index + 1}"
  }
}

# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
