#!/bin/bash

# Define authorized MAC addresses
authorized1="00:11:22:33:44:55"
authorized2="66:77:88:99:AA:BB"

# Get the current MAC address of your network interface (change eth0/wlan0 as needed)
current_mac=$(ip link show eth0 | awk '/ether/ {print $2}')

echo "Current MAC: $current_mac"

# Check if current MAC is authorized
if [[ "$current_mac" == "$authorized1" || "$current_mac" == "$authorized2" ]]; then
    echo "Access granted for $current_mac"
else
    echo "Unauthorized MAC address: $current_mac"
    echo "Access Denied."
    exit 1
fi

echo "Proceeding with script..."
# Place your code below