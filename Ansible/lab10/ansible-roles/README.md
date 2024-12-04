# Ansible Playbook for Automating Jenkins, Docker, and OpenShift CLI Installation

## Overview
This project uses Ansible to automate the setup and configuration of:
1. **Jenkins**: A popular automation server.
2. **Docker**: A containerization platform.
3. **OpenShift CLI (`oc`)**: A command-line tool for managing OpenShift clusters.

The project is structured using **Ansible roles** to ensure modularity and reusability.

---

## Directory Structure
```plaintext
project/
├── site.yml               # Main Ansible playbook
├── Intern_key.pem         # privte key paire
├── inventory              # Hosts file (not shown but expected for target servers)
├── roles/
│   ├── jenkins/           # Role for Jenkins
│   │   ├── tasks/         # Task files defining role actions
│   │   │   └── main.yml   # Main task file for Jenkins
│   ├── docker/            # Role for Docker
│   │   ├── tasks/         # Task files defining role actions
│   │   │   └── main.yml   # Main task file for Docker
│   ├── openshift_cli/     # Role for OpenShift CLI (`oc`)
│       ├── tasks/         # Task files defining role actions
│       │   └── main.yml   # Main task file for OpenShift CLI

```
# Usage Instructions
***Create an inventory file to define target hosts***
```bash
[all]
server1 ansible_host=192.168.1.10 ansible_user=ec2-user
```
## Define Tasks in main.yml Each role should have its own tasks/main.yml
### Jenkins Role: roles/jenkins/tasks/main.yml
```Yaml
---
    - name: Install required dependencies
      apt:
        name: "{{ item }}"
        state: present
      loop:
        - openjdk-17-jdk
        - gnupg
        - apt-transport-https
        - ca-certificates
        - curl
    - name: Download Jenkins repository GPG key
      ansible.builtin.command:
        cmd: wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian/jenkins.io-2023.key
      args:
        creates: /usr/share/keyrings/jenkins-keyring.asc

    - name: Add Jenkins APT repository
      ansible.builtin.shell:
        cmd: echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
      args:
        creates: /etc/apt/sources.list.d/jenkins.list

    - name: Update apt cache
      ansible.builtin.apt:
        update_cache: yes

    - name: Install Jenkins
      ansible.builtin.apt:
        name: jenkins
        state: present

    - name: Ensure Jenkins service is started and enabled
      ansible.builtin.service:
        name: jenkins
        state: started
        enabled: yes
```
### Docker Role: roles/docker/tasks/main.yml
```Yaml
---
- name: Install Docker
  ansible.builtin.yum:
    name: docker
    state: present

- name: Start and enable Docker service
  ansible.builtin.service:
    name: docker
    state: started
    enabled: yes

```
### OpenShift CLI Role: roles/openshift_cli/tasks/main.yml
```Yaml
---
- name: Download OpenShift CLI
  ansible.builtin.get_url:
    url: https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz
    dest: /tmp/oc.tar.gz

- name: Extract OpenShift CLI
  ansible.builtin.unarchive:
    src: /tmp/oc.tar.gz
    dest: /usr/local/bin
    remote_src: yes

- name: Set permissions for OpenShift CLI
  ansible.builtin.file:
    path: /usr/local/bin/oc
    mode: '0755'
```
## Update site.yml The main playbook (site.yml) calls the roles
```Yaml
---
- hosts: all
  become: yes
  roles:
    - jenkins
    - docker
    - openshift_cli
```

## Update the inventory file with your target hosts
```Yaml
      [all]
      ec2-51-20-1-107.eu-north-1.compute.amazonaws.com  ansible_ssh_user=ubuntu ansible_ssh_private_key_file=./Intern_key.pem
      13.49.68.231 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=./Intern_key.pem
```
### Run the playbook
```bash
      ansible-playbook -i inventory site.yml
```
## Verify that  Jenkins, Docker, and OpenShift CLI Installation  at target hosts
**Connect to Ec2 using ssh**
```bash
      ssh -i "Intern_key.pem" ubuntu@ec2-13-49-68-231.eu-north-1.compute.amazonaws.com
```
***Ensure Jenkins Installed****
```bash
      sudo systemctl status jenkins.server
```
***Ensure Doker Installed****
```bash
      sudo docker ps
```
***Ensure Openshift CLI Installed****
```bash
      oc version
```
# Some Problems and fix
**Installing Jenkins**
openjdk-17-jdk ------> must be 17 or higher
