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

# Usage Instructions

