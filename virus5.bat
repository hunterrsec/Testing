#!/bin/bash

# === CONFIGURABLE SECTION ===
ALLOWED_MAC_1="00:11:22:33:44:55"
ALLOWED_MAC_2="AA:BB:CC:DD:EE:FF"
ENCRYPTED_ZIP="secured_repo.7z"
OUTPUT_FOLDER="decrypted_repo"
ZIP_PASSWORD="StrongPassword123"
SEVEN_ZIP_BIN="/usr/bin/7z"  # Or use `7zr` or `7za` if that's what you have
# =============================

# Get system MAC address (first non-loopback interface)
CURRENT_MAC=$(ip link | awk '/ether/ {print $2; exit}')

if [[ "$CURRENT_MAC" != "$ALLOWED_MAC_1" && "$CURRENT_MAC" != "$ALLOWED_MAC_2" ]]; then
  echo "[ERROR] Access Denied. Your MAC address ($CURRENT_MAC) is not allowed."
  exit 1
fi

echo "[INFO] Access Granted for MAC: $CURRENT_MAC"
echo "[INFO] Decrypting Repository..."

if [ ! -f "$ENCRYPTED_ZIP" ]; then
  echo "[ERROR] Encrypted file not found: $ENCRYPTED_ZIP"
  exit 1
fi

$SEVEN_ZIP_BIN x "$ENCRYPTED_ZIP" -o"$OUTPUT_FOLDER" -p"$ZIP_PASSWORD" -y

if [ $? -ne 0 ]; then
  echo "[ERROR] Decryption failed. Check password or file integrity."
  exit 1
fi

echo "[SUCCESS] Repository decrypted to folder: $OUTPUT_FOLDER"
