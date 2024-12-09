provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    {
      Name = "${var.environment}-vpc"
    },
    var.vpc_tags
  )
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "${var.environment}-public-subnet"
    },
    var.vpc_tags
  )
}
# Security Group
resource "aws_security_group" "allow_traffic" {
  name        = "${var.environment}-allow-traffic"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name        = "${var.environment}-allow-traffic"
    Environment = var.environment
  }
}

# SNS Topic
resource "aws_sns_topic" "monitoring_alerts" {
  name = "${var.environment}-monitoring-alerts"
}

# SNS Topic Policy
resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.monitoring_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudWatchAlarms"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.monitoring_alerts.arn
      }
    ]
  })
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.monitoring_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "vpc_flow_logs" {
  alarm_name          = "${var.environment}-vpc-flow-logs-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name        = "RejectedConnectionCount"
  namespace          = "AWS/VPC"
  period             = "300"
  statistic          = "Sum"
  threshold          = var.alarm_threshold
  alarm_description  = "This metric monitors rejected VPC connections"
  alarm_actions      = [aws_sns_topic.monitoring_alerts.arn]

  dimensions = {
    VpcId = aws_vpc.main.id
  }
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = "/aws/vpc/flow-logs-${var.environment}"
  retention_in_days = var.flow_log_retention_days
}
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.allow_traffic.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Terraform Version $(date)</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "${var.environment}-web-server"
    CreatedAt = timestamp()
    Version = "1.0"
  }

  lifecycle {
    create_before_destroy = true
  }

  # Add this to ensure the instance gets a public IP
  associate_public_ip_address = true
}



