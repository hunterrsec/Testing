#!/bin/bash

# === CONFIGURATION ===

ENCRYPTION_KEY="eFTbxnvTGHyVnShSR3OxO6PGFv6L7IJHjmvRNH2JX4g="
SENSITIVE_FILE="/home/username/Gitpush/Testfile.py" # Change this to your path

AUTHORIZED_MACS=(
    "04:33:C2:C9:B3:18"
    "00:1A:2B:3C:4D:5E"
    "66:77:88:99:AA:BB"
)

# === FUNCTIONS ===

check_mac() {
    CURRENT_MAC=$(ip link show | awk '/ether/ {print $2}' | head -n 1)
    echo "[INFO] Current MAC: $CURRENT_MAC"
    for AUTH_MAC in "${AUTHORIZED_MACS[@]}"; do
        if [[ "$CURRENT_MAC" == "$AUTH_MAC" ]]; then
            echo "[INFO] Authorized device detected."
            return 0
        fi
    done
    echo "[ERROR] Unauthorized device. Access denied."
    exit 1
}

encrypt_file() {
    if [ ! -f "$SENSITIVE_FILE" ]; then
        echo "[WARNING] $SENSITIVE_FILE does not exist."
        return
    fi
    openssl enc -aes-256-cbc -salt -pbkdf2 -in "$SENSITIVE_FILE" -out "$SENSITIVE_FILE.enc" -pass pass:$ENCRYPTION_KEY
    if [ $? -eq 0 ]; then
        rm "$SENSITIVE_FILE"
        echo "[INFO] Encrypted $SENSITIVE_FILE"
    else
        echo "[ERROR] Encryption failed for $SENSITIVE_FILE"
    fi
}

decrypt_file() {
    if [ ! -f "$SENSITIVE_FILE.enc" ]; then
        echo "[WARNING] $SENSITIVE_FILE.enc not found."
        return
    fi
    openssl enc -d -aes-256-cbc -pbkdf2 -in "$SENSITIVE_FILE.enc" -out "$SENSITIVE_FILE" -pass pass:$ENCRYPTION_KEY
    if [ $? -eq 0 ]; then
        echo "[INFO] Decrypted $SENSITIVE_FILE"
    else
        echo "[ERROR] Decryption failed for $SENSITIVE_FILE"
    fi
}

# === MAIN EXECUTION ===

read -p "Enter action (protect/unlock): " action

if [[ "$action" == "protect" ]]; then
    encrypt_file
elif [[ "$action" == "unlock" ]]; then
    check_mac
    decrypt_file
else
    echo "[ERROR] Invalid action. Use 'protect' or 'unlock'."
fi
