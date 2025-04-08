#!/bin/bash

# === Config ===
ALLOWED_MAC="00:1A:2B:3C:4D:5E"
ENCRYPTED_FILE="repo_encrypted.bin"
DECRYPTED_FILE="repo.zip"
PASSWORD="StrongPassword"

# === Get MAC address ===
CURRENT_MAC=$(ip link show | awk '/ether/ {print $2; exit}')
echo "Detected MAC: $CURRENT_MAC"

if [ "$CURRENT_MAC" == "$ALLOWED_MAC" ]; then
    echo "MAC address authorized. Proceeding with decryption..."
else
    echo "Unauthorized device. Extraction aborted."
    exit 1
fi

# === Decrypt the file ===
openssl enc -aes-256-cbc -d -in "$ENCRYPTED_FILE" -out "$DECRYPTED_FILE" -k "$PASSWORD"
if [ $? -ne 0 ]; then
    echo "Decryption failed!"
    exit 1
fi

echo "Decryption successful. Extracting..."

# === Extract the ZIP file ===
unzip "$DECRYPTED_FILE" -d extracted/
if [ $? -ne 0 ]; then
    echo "Extraction failed!"
    exit 1
fi

echo "Extraction completed successfully!"