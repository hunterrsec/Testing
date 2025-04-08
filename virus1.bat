#!/bin/bash

# Define the allowed MAC addresses (up to 10)
ALLOWED_MACS=(
     "12:34:56:78:9A:BC"
    "98:76:54:32:10:FE"
    "A1:B2:C3:D4:E5:F6"
    "B7:C8:D9:E0:F1:A2"
    "C3:D4:E5:F6:A7:B8"
    "D9:E0:F1:A2:B3:C4"
)

# Get the current MAC address of the first network interface
CURRENT_MAC=$(ip link show | awk '/ether/ {print $2; exit}')

echo "Current MAC: $CURRENT_MAC"

# Check if the current MAC is in the allowed list
AUTHORIZED=false
for MAC in "${ALLOWED_MACS[@]}"; do
    if [[ "$CURRENT_MAC" == "$MAC" ]]; then
        AUTHORIZED=true
        break
    fi
done

if $AUTHORIZED; then
    echo "✅ MAC address is authorized."
else
    echo "🚨 WARNING: Unauthorized MAC detected!" | tee -a unauthorized_access.log
    echo "Date: $(date)" | tee -a unauthorized_access.log
    echo "Detected MAC: $CURRENT_MAC" | tee -a unauthorized_access.log
    echo "" >> unauthorized_access.log

    # Send an email notification (requires `mail` command)
    EMAIL="support@imadeasong.com"
    SUBJECT="ALERT: Unauthorized MAC Access Detected"
    MESSAGE="Unauthorized MAC detected!\n\nDate: $(date)\nDetected MAC: $CURRENT_MAC\n\nImmediate action is required."
    echo -e "$MESSAGE" | mail -s "$SUBJECT" "$EMAIL"

    # Optional: Disable Git temporarily
    alias git="echo 'Unauthorized access detected. Git is disabled.'"

    exit 1
fi