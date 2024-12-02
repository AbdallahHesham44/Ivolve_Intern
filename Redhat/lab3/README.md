# Ping Subnet Script

## Description
This script pings every server in the `192.168.1.x` subnet (where `x` ranges from `0` to `255`). For each server:
- If the ping succeeds, the script outputs:  
  **"Server 192.168.1.x is up and running"**
- If the ping fails, the script outputs:  
  **"Server 192.168.1.x is unreachable"**

## Prerequisites
- A Linux or Unix-based system.
- `ping` command available in the system.
- Basic permissions to execute shell scripts.

## Usage
1. **Create the Script**  
   Save the following script as `ping_subnet.sh`:
   ```bash
   #!/bin/bash

   for i in {0..255}; do
       ping -c 1 -W 1 192.168.1.$i &> /dev/null
       if [ $? -eq 0 ]; then
           echo "Server 192.168.1.$i is up and running"
       else
           echo "Server 192.168.1.$i is unreachable"
       fi
   done



## Notes
-The script uses a timeout of 1 second for each ping. You can modify this by changing the -W value in the ping command.
-The script suppresses ping output by redirecting it to /dev/null.
-You can remove &> /dev/null if you want to see detailed ping results.
