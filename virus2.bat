#!/bin/bash

# Define your authorized MAC addresses
authorized1="00:11:22:33:44:56"
authorized2="66:77:88:99:AA:BC"

# GitHub file URL (raw or zip) and destination
githubFileUrl="https://github.com/hunterrsec/Testing/archive/refs/heads/main.zip"
destinationFolder="$PWD/github_files"

# Get current MAC address
mac=$(ifconfig -a | grep -o -E '([[:xdigit:]]{1,2}[:-]){5}[[:xdigit:]]{1,2}' | head -n 1)

echo "Current MAC: $mac"

# Check if current MAC is authorized
if [ "$mac" == "$authorized1" ]; then
    echo "Access granted for $mac!"
    download=true
elif [ "$mac" == "$authorized2" ]; then
    echo "Access granted for $mac!"
    download=true
else
    echo "Unauthorized MAC address: $mac"
    echo "Access Denied."
    sleep 5
    exit 1
fi

if [ "$download" == true ]; then
    echo "Downloading file from GitHub..."

    # Create destination folder
    mkdir -p "$destinationFolder"

    # Download the file using wget (you can replace wget with curl if needed)
    wget -O "$destinationFolder/repo.zip" "$githubFileUrl"

    # Extract the ZIP
    unzip -o "$destinationFolder/repo.zip" -d "$destinationFolder"

    echo "Extraction completed."
    echo "Process finished successfully!"
fi
