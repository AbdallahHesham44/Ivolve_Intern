
# AWS VPC with Public Subnets and EC2 Instances

This project sets up an AWS Virtual Private Cloud (VPC) with two public subnets, an Internet Gateway, a public route table, and two EC2 instances running in separate subnets. 

## Prerequisites

1. **Terraform**: Ensure Terraform is installed on your local machine. [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
2. **AWS Account**: You need an AWS account and proper IAM credentials with permissions to manage VPCs, subnets, EC2 instances, and related resources.
3. **AWS CLI**: Optional, but useful for verifying resources. [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

## Project Structure

```plaintext
.
├── main.tf             # Main Terraform configuration
├── outputs.tf
├── modules/
│   └── ec2/            # EC2 module
│       ├── main.tf     # EC2 module definition
│       └── variables.tf
└── README.md           # Project documentation
```

## Features

- **VPC**: A VPC with DNS support and hostnames enabled.
- **Public Subnets**: Two public subnets in different availability zones.
- **Internet Gateway**: Allows internet access.
- **Route Table**: Configured to route traffic to the internet gateway.
- **Security Group**: Opens ports for HTTP (80) and SSH (22).
- **EC2 Instances**: Two NGINX servers, one in each subnet.

## Configuration Details

### VPC

Creates a VPC with a CIDR block of `10.0.0.0/16`:
- DNS support and hostnames are enabled for ease of use.

### Subnets

- **Public Subnet 1**: `10.0.1.0/24`, located in `us-east-1a`.
- **Public Subnet 2**: `10.0.2.0/24`, located in `us-east-1b`.

### Internet Gateway

The VPC includes an internet gateway, allowing instances in public subnets to access the internet.

### Route Table

A public route table is created, with:
- A route for `0.0.0.0/0` pointing to the internet gateway.
- Both public subnets associated with this route table.

### Security Group

A security group (`nginx-sg`) is created with the following rules:
- **Inbound**:
  - HTTP traffic (port 80) from anywhere.
  - SSH traffic (port 22) from anywhere.
- **Outbound**: All traffic allowed.

### EC2 Module

- Two EC2 instances are provisioned using a module located at `modules/ec2`.
- Instances are distributed across public subnets.
- Each instance is assigned the `nginx-sg` security group.

## Usage

### Step 1: Clone the Repository

```bash
git clone <repository-url>
cd <repository-directory>
```
```plaintext
https://github.com/AbdallahHesham44/Ivolve_Training/edit/main/
```

### Step 2: Initialize Terraform

Run the following command to initialize Terraform and download the required providers:

```bash
terraform init
```

### Step 3: Plan and Apply

To preview the changes:

```bash
terraform plan
```

To apply the changes and create the infrastructure:

```bash
terraform apply
```

Type `yes` to confirm.

### Step 4: Verify

- Use the AWS Management Console to verify that the resources are created.
- Use the AWS CLI to check resources:
  ```bash
  aws ec2 describe-vpcs --filters "Name=tag:Name,Values=main-vpc"
  ```
- Ues Output file to print the IPs of EC2
  
  ![image](https://github.com/user-attachments/assets/66954625-8208-4e27-8d54-a86611e56668)


### Step 5: Destroy (Optional)

To destroy the infrastructure:

```bash
terraform destroy
```

Type `yes` to confirm.
Or Add  -auto-approve
```bash
terraform destroy -auto-approve
```
---

