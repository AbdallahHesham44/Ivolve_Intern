# SSH Key Authentication Setup and Simplified Access

## Description
This document explains the steps to:
1. Generate an SSH key pair.
2. Copy the public key to a remote EC2 instance.
3. Configure SSH to connect to the instance with a simplified command (`ssh ivolve`).

## Prerequisites
- A local machine (Linux or macOS).
- Access to an EC2 instance.
- Private key (`.pem`) used to launch the EC2 instance.
- Public key that will be used for authentication.

## Steps

### **1. Generate SSH Key Pair**
1. Open a terminal on your local machine.
2. Generate a new SSH key pair using the following command:
   ```bash
   ssh-keygen -t rsa -b 2048 -f ~/.ssh/ivolve_key -C "ivolve_key"
```

