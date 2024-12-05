# AWS Lab Step-by-Step Guide

This **README** file provides a step-by-step guide for setting up and managing your AWS account, configuring IAM groups and users, and performing specified tasks.

---

## **Step 1: Create an AWS Account**

1. Go to [AWS Sign Up](https://aws.amazon.com/).
2. Fill in the required details, verify your identity, and choose a support plan.
3. After setup, log in to the **AWS Management Console**.

---

## **Step 2: Set Up Billing Alarm**

1. Navigate to the **Billing Dashboard** in the AWS Console.
2. Go to **Budgets** > **Create Budget**.
3. **Choose Budget Type**: Cost Budget.
4. **Set Thresholds**: Specify the monthly budget amount (e.g., $10).
5. Configure **Email Alerts** for the budget threshold.
6. Review and create the budget.

---

## **Step 3: Create IAM Groups**

1. Navigate to the **IAM Console** > **Groups**.
2. Click **Create Group**:
   - **Group Name**: `AdminGroup`.
   - Attach the **AdministratorAccess** policy.
   - Click **Create Group**.
3. Create another group:
   - **Group Name**: `DeveloperGroup`.
   - Attach the **AmazonEC2FullAccess** policy.
   - Click **Create Group**.

---

## **Step 4: Create IAM Users**

### **1. Admin-1 User with Console Access Only**
1. Go to the **IAM Console** > **Users** > **Add Users**.
2. **User Name**: `admin-1`.
3. **Access Type**: Select **AWS Management Console Access**.
4. **Password Options**: Set a custom password.
5. Assign the user to the **AdminGroup**.
6. Click **Create User**.
7. Enable MFA:
   - Go to the **Users** section and select `admin-1`.
   - In the **Security Credentials** tab, click **Manage MFA**.
   - Follow the instructions to set up MFA using an authenticator app.

---

### **2. Admin-2-Prog User with CLI Access Only**
1. Go to **IAM Console** > **Users** > **Add Users**.
2. **User Name**: `admin-2-prog`.
3. **Access Type**: Select **Programmatic Access**.
4. Assign the user to the **AdminGroup**.
5. Click **Create User** and download the **Access Key ID** and **Secret Access Key**.

---

### **3. Dev-User with Programmatic and Console Access**
1. Go to **IAM Console** > **Users** > **Add Users**.
2. **User Name**: `dev-user`.
3. **Access Type**: Select both **Programmatic Access** and **AWS Management Console Access**.
4. Assign the user to the **DeveloperGroup**.
5. Click **Create User** and download the **Access Key ID** and **Secret Access Key**.

---

## **Step 5: List All Users and Groups Using AWS CLI**

1. Configure the CLI:
   ```bash
   aws configure
   ```




Access denied for S3 dev-user
![image](https://github.com/user-attachments/assets/cd1a81e8-1904-49a6-9bae-e37781f08642)
EC2 Lunched 
![image](https://github.com/user-attachments/assets/68ba9dc1-918f-4615-b34c-f333eee5a9fe)
