#!/bin/bash

# Iterate through the range 0 to 255 for the last octet
for i in {0..255}; do
    # Ping the server with a timeout of 1 second
    ping -c 1 -W 1 192.168.1.$i &> /dev/null
    
    # Check the exit status of the ping command
    if [ $? -eq 0 ]; then
        echo "Server 192.168.1.$i is up and running"
    else
        echo "Server 192.168.1.$i is unreachable"
    fi
done

