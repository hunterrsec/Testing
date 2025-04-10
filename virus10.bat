#!/bin/bash

# === CONFIGURATION ===
ALLOWED_MAC="00:11:22:33:44:55"
ZIP_FILE="secure_data.zip"
EXTRACT_TO="SecureContent"
ZIP_PASSWORD="MyStrongPassword"
SEVENZIP_BIN="/usr/bin/7z"  # Adjust if needed
# =======================

# Get the first MAC address (non-virtual)
CURRENT_MAC=$(ip link | awk '/ether/ {print $2; exit}')
echo "[INFO] Detected MAC: $CURRENT_MAC"

if [[ "$CURRENT_MAC" == "$ALLOWED_MAC" ]]; then
    echo "[INFO] Authorized device. Extracting..."
    "$SEVENZIP_BIN" x "$ZIP_FILE" -o"$EXTRACT_TO" -p"$ZIP_PASSWORD" -y
else
    echo "[ERROR] Unauthorized MAC address. Access denied."
fi
