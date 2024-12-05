# AWS Lab: VPC with Public and Private Subnets

This guide walks you through the creation of a VPC with public and private subnets, launching EC2 instances in each subnet, and configuring secure SSH access to the private instance using a bastion host.

---

## **Step 1: Create a VPC**

1. Navigate to the **VPC Console** in AWS.
2. Click **Create VPC**.
3. Enter the following details:
   - **Name Tag**: `MyVPC`
   - **IPv4 CIDR block**: `10.0.0.0/16`
   - **Tenancy**: Default
4. Click **Create VPC**.
---
![image](https://github.com/user-attachments/assets/e848fc9a-9c26-4d5c-990a-103381b608ba)


## **Step 2: Create Subnets**

### **1. Public Subnet**
1. In the **VPC Console**, select **Subnets** > **Create Subnet**.
2. Enter the following details:
   - **Name Tag**: `PublicSubnet`
   - **VPC**: Select `MyVPC`.
   - **IPv4 CIDR Block**: `10.0.1.0/24`.
   - **Availability Zone**: Select one of your choice.
3. Click **Create Subnet**.

![image](https://github.com/user-attachments/assets/4b94a5a9-c53f-44fe-8da3-84fa9761dd74)


### **2. Private Subnet**
1. Repeat the above steps for the private subnet:
   - **Name Tag**: `PrivateSubnet`
   - **VPC**: Select `MyVPC`.
   - **IPv4 CIDR Block**: `10.0.2.0/24`.
   - **Availability Zone**: Same as the public subnet.
2. Click **Create Subnet**.
---

![image](https://github.com/user-attachments/assets/573cfbff-1e67-4cf3-9c7b-d77b38e92950)


## **Step 3: Configure the Public Subnet for Internet Access**

1. In the **VPC Console**, go to **Route Tables**.
2. Select the route table associated with `MyVPC` and click **Edit Routes**.
3. Add the following rule:
   - **Destination**: `0.0.0.0/0`
   - **Target**: `Internet Gateway (IGW)`
4. Click **Save Changes**.

5. Attach an Internet Gateway to the VPC:
   - Go to **Internet Gateways** > **Create Internet Gateway**.
   - Name it `MyInternetGateway`, attach it to `MyVPC`.
---

![image](https://github.com/user-attachments/assets/5efe237f-e714-4e16-8c89-75e18a20ef49)

## **Step 4: Launch EC2 Instances**

### **1. Launch Public EC2 Instance**
1. Go to the **EC2 Console** > **Launch Instance**.
2. Select an AMI (e.g., Amazon Linux 2).
3. Select an instance type (e.g., `t2.micro`).
4. **Network Settings**:
   - **VPC**: Select `MyVPC`.
   - **Subnet**: Select `PublicSubnet`.
   - **Auto-assign Public IP**: Enable.
5. Create a security group `PublicSG`:
   - **Inbound Rule**: Allow SSH (port 22) from your public IP (e.g., `203.0.113.0/32`).
6. Add your key pair and launch the instance.

![image](https://github.com/user-attachments/assets/f31c9180-e155-4d22-9ced-8cc170f26f53)


### **2. Launch Private EC2 Instance**
1. Repeat the steps above but select `PrivateSubnet`.
2. **Network Settings**:
   - **VPC**: Select `MyVPC`.
   - **Subnet**: Select `PrivateSubnet`.
   - **Auto-assign Public IP**: Disable.
3. Create a security group `PrivateSG`:
   - **Inbound Rule**: Allow SSH (port 22) from the private IP of the Public EC2 instance (e.g., `10.0.1.10/32`).
---

![image](https://github.com/user-attachments/assets/3332d5f5-2855-4f97-bfac-d4d6c68f92b3)


## **Step 5: SSH to the Private EC2 via the Public EC2**

### **1. Connect to the Public EC2**
From your local machine, SSH into the public EC2 instance:
```bash
ssh -i "your-key.pem" ec2-user@<PublicEC2_Public_IP>
```


