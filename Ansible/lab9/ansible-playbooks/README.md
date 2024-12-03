# Ansible Playbook to Install MySQL and Configure ivolve Database

This guide will walk you through setting up MySQL on a managed host using Ansible, creating the `ivolve` database, and securing access by creating a new user with the required privileges. Sensitive data (such as database passwords) is encrypted using **Ansible Vault**.

## Prerequisites

- Ansible installed on your local machine.
- A managed host (e.g., EC2 instance) with Ubuntu running.
- Access to the managed host via SSH.

---

## Steps

### Step 1:Encrypt Sensitive Information with Ansible Vault
**Create a Vault file:**

    ```bash
   ansible-vault create vault.yml
    ```
**Add the following content (modify the values as needed):**

    ``` bash
    db_user: ivolve_user
    db_password: secure_password123
    ```
**Save and close. You’ll be prompted to set a password for the vault.**
***To view or edit the Vault file later:***
    ```bash
   ansible-vault edit vault.yml
    ```
### Step 2:  Write the Ansible Playbook
**Create a playbook file:**
    ```bash
   nano install_mysql.yml
    ```
**Add the following content:**
    ```bash
    ---
- name: Install MySQL and configure ivolve database
  hosts: all
  become: yes
  vars_files:
    - vault.yml

  tasks:
    - name: Update the package list
      apt:
        update_cache: yes

    - name: Install MySQL server
      apt:
        name: mysql-server
        state: present

    - name: Start and enable MySQL service
      service:
        name: mysql
        state: started
        enabled: yes

    - name: Install Python MySQL dependencies
      apt:
        name: python3-pymysql
        state: present
    - name: Create ivolve database
      mysql_db:
        name: ivolve
        state: present
        login_user: root
        login_password: "{{ mysql_root_password }}"

    - name: Create ivolve user and grant privileges
      mysql_user:
        name: "{{ db_user }}"
        password: "{{ db_password }}"
        priv: "ivolve.*:ALL"
        state: present
        login_user: root
        login_password: "{{ mysql_root_password }}"


    ```
***Run the Playbook***
    ```bash
        ansible-playbook -i inventory install_mysql.yml --ask-vault-pass
    ```
    

  ### Step 4: Fix some Issues
  **Understand the Problem**
    MySQL root user might:
    
    Require a password for login.
    Use Unix socket authentication, meaning it can only log in from the local host without a password, relying on the operating system's authentication.
    By default, Ansible's mysql_db and mysql_user modules try to connect as root without a password unless explicitly specified.
    
**Fix the Issue**
 **1. Log into your managed host (e.g., EC2 instance) using SSH.**
  
    ```bash
    ssh -i /path/to/private_key.pem ubuntu@<ec2_public_ip>
    ```
  
**2.Set the root password during or after MySQL installation (if not done already):**
    ```bash
      sudo mysql
      ALTER USER 'root'@'localhost' IDENTIFIED BY '12345';
      FLUSH PRIVILEGES;
    ```
  **3. Update your playbook to include the root password:**
    ```bash
      - name: Create ivolve database
        mysql_db:
          name: ivolve
          state: present
          login_user: root
          login_password: "{{ mysql_root_password }}"
    ```
   **4. Add the mysql_root_password variable in your Vault file:**
      ```yaml 
      mysql_root_password: your_root_password
      ```
   **5. Rerun the playbook with the vault:**
      ```bash
       ansible-playbook -i inventory install_mysql.yml --ask-vault-pass
      ```
      
