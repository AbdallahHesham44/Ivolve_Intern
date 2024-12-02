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
