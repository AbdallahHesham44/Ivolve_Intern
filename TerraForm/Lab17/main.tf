data "aws_vpc" "ivolve" {
  filter {
    name   = "tag:Name"
    values = ["ivolve"]
  }
}
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = data.aws_vpc.ivolve.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "ivolve-public-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = data.aws_vpc.ivolve.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  
  tags = {
    Name = "ivolve-private-subnet-1"
  }
}
# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = data.aws_vpc.ivolve.id

  tags = {
    Name = "ivolve-igw"
  }
}

# Create a route table
resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.ivolve.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "ivolve-public-rt"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_instance" "web_server" {
  ami           = "ami-0e2c8caa4b6378d8c"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name      = "firstKey_Ansible"  # Make sure to update this

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ec2-ip.txt"
  }

  tags = {
    Name = "ivolve-web-server"
  }
}

# Security Group for Web Server
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Security group for web server"
  vpc_id      = data.aws_vpc.ivolve.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
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

  tags = {
    Name = "web-server-sg"
  }
}

# Security Group for RDS
resource "aws_security_group" "db_sg" {
  name        = "database-sg"
  description = "Security group for database"
  vpc_id      = data.aws_vpc.ivolve.id

  ingress {
    description     = "MySQL from web server"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-sg"
  }
}
resource "aws_db_subnet_group" "default" {
  name       = "ivolve-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.public_subnet_1.id]

  tags = {
    Name = "ivolve DB subnet group"
  }
}



resource "aws_db_instance" "my-db" {
  identifier           = "ivolve-database"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  db_name             = "ivolvedb"
  username            = "admin"
  password            = "1234567899"  # Make sure to update this
  parameter_group_name = "default.mysql8.0"
  
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  skip_final_snapshot  = true
}
