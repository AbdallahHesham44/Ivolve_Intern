# Disk Space Usage Monitoring Script

This script automates checking the disk space usage of the root file system and sends an email alert if the usage exceeds a specified threshold. The default threshold is set to **10%**.

## Prerequisites

Ensure the following tools and libraries are installed on your system:

1. **`bash`**: The script runs in a Bash shell (default in most Linux distributions).
2. **`msmtp`**: Used to send emails via an SMTP server.
3. **`df`**: To monitor disk usage (installed by default on Linux).

### Installation of Required Libraries

1. **Install `msmtp`**:
   ```bash
   sudo apt update
   sudo apt install msmtp msmtp-mta -y
```
2. **Edite msmtprc file**:
   ```bash
   vim ~/.msmtprc
```
```bash
# Gmail SMTP settings
account gmail
host smtp.gmail.com
port 587
from abdallah.hesham.102@gmail.com
auth on
user abdallah.hesham.102@gmail.com
password kpvt uupy isek bzdu
tls on
tls_starttls on
logfile ~/.msmtp.log

# Set default account to gmail
account default : gmail
```
3. ** Test Setup **:
   ```bash
  echo "Test email body" | mail -s "Test email subject" abdallah.hesham.102@gmail.com
```

3. ** Schedule a script **:
```bash
vim disk_space_monitor.sh
```
*** Add code ***
```bash
#!/bin/bash

# Disk Space Monitoring Script
# Checks root filesystem disk usage and sends email alert if exceeds 10% threshold

# Configuration
THRESHOLD=10
EMAIL="abdallah.hesham.102@gmail.com"
HOSTNAME=$(hostname)

# Function to send email alert
send_alert() {
    local usage=$1
    local subject="DISK SPACE ALERT: ${HOSTNAME} Root Filesystem ${usage}% Full"
    local message="Warning: Root filesystem disk usage has exceeded ${THRESHOLD}%!

Current Usage: ${usage}%

Please investigate and free up disk space to prevent potential system issues."

    echo "$message" | mail -s "$subject" "$EMAIL"
}

# Check disk usage
USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

# Compare usage against threshold
if (( $(echo "$USAGE > $THRESHOLD" | bc -l) )); then
    send_alert "$USAGE"
fi
```

4. ** Schedule a script every day at 05:00 pm **:
```bash
crontab -e

#Add the following line to schedule the script:
0 17 * * * /path/to/check_disk_space.sh
path:
/home/abdallah/new_repo/Ivolve_Training/Redhat/lab2
``` 


