#!/bin/bash

# === Configuration ===
ALLOWED_MAC="00:11:22:33:44:55"   # Update this
ZIP_FILE="secure_data.7z"
ZIP_PASSWORD="MyStrongPassword"
EXTRACT_TO="SecureFolder"
SEVENZIP_CMD="7z"
# =====================

echo "[INFO] Checking MAC address..."

# Get MAC (first interface that's not virtual/lo)
CURRENT_MAC=$(ip link show | grep ether | head -n1 | awk '{print $2}')

echo "[INFO] Detected MAC: $CURRENT_MAC"
echo "[INFO] Allowed MAC : $ALLOWED_MAC"

if [[ "$CURRENT_MAC" == "$ALLOWED_MAC" ]]; then
    echo "[OK] Authorized device."
    mkdir -p "$EXTRACT_TO"
    $SEVENZIP_CMD x "$ZIP_FILE" -p"$ZIP_PASSWORD" -o"$EXTRACT_TO" -y
    if [[ $? -eq 0 ]]; then
        echo "[DONE] Extraction successful to '$EXTRACT_TO'"
    else
        echo "[ERROR] Extraction failed. Wrong password or missing file."
    fi
else
    echo "[DENIED] Unauthorized MAC address. Access denied."
    exit 1
fi
