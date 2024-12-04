# Ansible: Dynamic Inventory and Apache Installation Using Ansible Galaxy  

## Overview  
This project demonstrates how to:  
1. Set up **Ansible Dynamic Inventories** to automatically discover and manage infrastructure, specifically for AWS EC2 instances.  
2. Use an **Ansible Galaxy role** to install and configure Apache on the target servers.  

---

## Prerequisites  
- Ansible 2.9+  
- Python 3.6+  
- AWS CLI configured with valid credentials (`aws configure`)  
- Python libraries: `boto3` and `botocore`  
- SSH access to target servers  

---

## Project Structure  
```plaintext
project/
├── ansible.cfg              # Ansible configuration file
├── ec2.py                   # Dynamic inventory script for AWS
├── site.yml                 # Main playbook to install Apache
├── galaxy_roles/            # Directory for Galaxy roles
│   └── geerlingguy.apache/  # Installed Apache role

```
# Step-by-Step Guide
**Set Up AWS Dynamic Inventory**
Dynamic inventory allows Ansible to fetch EC2 instance details automatically.
```bash
       sudo apt install python3-boto3
       sudo apt install python3-botocore
```

**Set Up AWS Dynamic Inventory**
Configure AWS CLI with your credentials
```bash
       sudo apt install awscli
       aws configure
```
***Install Ansible AWS***
```bash
        sudo ansible-galaxy collection install amazon.aws
```
## Install Apache Using Ansible Galaxy Role

Ansible Galaxy simplifies the process of configuring software like Apache.
```bash
        ansible-galaxy search apache
```
Install the geerlingguy.apache role
```bash
        ansible-galaxy install geerlingguy.apache --roles-path galaxy_roles/
```
play book install Apache
**Create install_apache.yml**
```yaml
---
- name: Install Apache
  hosts: all
  become: yes
  roles:
    - geerlingguy.apache

```
**Run command**
  
  ```bash
      ansible-inventory -i <Dynamic Inventory > <play Book> 
  ```
  ```bash
      ansible-inventory -i aws_ec2.yml install_apache.yml 
  ```
## Ensure the Role is Installed
**Run the following command to install the role in a specific directory:**
```bash
       ansible-galaxy install geerlingguy.apache --roles-path ./roles
```
## Verify apache installed in hosts
```bash
       ansible all -i aws_ec2.yml -m command -a " systemctl status apache2 "
```
# Some Issues and tips

## 1-install boto3 use:
    ```bash
    sudo apt install python3-<libarary>
    ```
    
    ```bash
    sudo apt install python3-boto3
    ```

## 2- name of inventory file
must be **aws_ec2.yml**

## 3- credintial must have the permision to create Ec2
