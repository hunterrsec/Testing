#!/bin/bash

# === CONFIGURATION ===
ALLOWED_MAC_1="00:11:22:33:44:55"
ALLOWED_MAC_2="AA:BB:CC:DD:EE:FF"
ENCRYPTED_ZIP="Testing-secured.7z"
OUTPUT_FOLDER="Testing-Decrypted"
ZIP_PASSWORD="StrongPassword123"
SEVEN_ZIP_BIN="/usr/bin/7z"  # Update if different on your system
# =======================

# Get the current MAC address (first physical interface)
CURRENT_MAC=$(ip link | awk '/ether/ {print $2; exit}')

echo "[INFO] Detected MAC: $CURRENT_MAC"

# Check if MAC is allowed
if [[ "$CURRENT_MAC" != "$ALLOWED_MAC_1" && "$CURRENT_MAC" != "$ALLOWED_MAC_2" ]]; then
  echo "[ERROR] Access Denied. This device is not authorized to unzip the file."
  exit 1  # 👈 Stops script here — no unzip will happen
fi

echo "[INFO] Access Granted for MAC: $CURRENT_MAC"
echo "[INFO] Proceeding to decrypt the repository..."

# Check if encrypted file exists
if [ ! -f "$ENCRYPTED_ZIP" ]; then
  echo "[ERROR] Encrypted file not found: $ENCRYPTED_ZIP"
  exit 1
fi

# Decrypt using 7z
$SEVEN_ZIP_BIN x "$ENCRYPTED_ZIP" -o"$OUTPUT_FOLDER" -p"$ZIP_PASSWORD" -y

# Check if unzip succeeded
if [ $? -ne 0 ]; then
  echo "[ERROR] Decryption failed. Incorrect password or file error."
  exit 1
fi

echo "[SUCCESS] Repository successfully decrypted to folder: $OUTPUT_FOLDER"
