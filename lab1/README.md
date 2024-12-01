# User and Group Management for Passwordless Nginx Installation

This repository provides a guide and steps to create a group and user, add the user to the group, and configure passwordless installation of Nginx for members of the group.

---

## Steps

### 1. Create a Group
Run the following command to create a new group:
```bash
sudo groupadd <group_name>
sudo groupadd ivolve
```

![Process Overview](./lab1/createGroupAndUser.jpeg)


### 2. Create a User
Run the following command to create a new User:
```bash
sudo useradd -m -s /bin/bash -G ivolve <user_name>
sudo useradd -m -s /bin/bash -G ivolve abdallahU
```

### 3. Create a password to this User
Run the following command to create a password for  User:
```bash
sudo passwd <user_name>
sudo passwd abdallahU
```

### 3. Run Command with No password
Add the following line to give members of the group permission to run apt install nginx without a passwordr:
```bash
%<group_name> ALL=(ALL) NOPASSWD: Command i want allow user to run with No password
abdallahU ALL=(ALL) NOPASSWD: /usr/bin/apt install nginx
```

### 3. Test the Setup
First switch to user:
```bash
su - abdallahU
```
Run the command to install Nginx:
```bash
sudo apt install nginx
```


