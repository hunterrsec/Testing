#!/bin/bash

# === CONFIGURATION ===
ALLOWED_MAC="00:11:22:33:44:55"
SEVEN_ZIP_BIN="/usr/bin/7z"
GIT_ARCHIVE=".git-secure.7z"
GIT_PASSWORD="StrongGitPassword"
GIT_OUTPUT=".git"
# =======================

# Get first physical MAC address
CURRENT_MAC=$(ip link | awk '/ether/ {print $2; exit}')
echo "[INFO] Detected MAC: $CURRENT_MAC"

if [[ "$CURRENT_MAC" == "$ALLOWED_MAC" ]]; then
  echo "[INFO] MAC authorized. Unlocking .git..."
  $SEVEN_ZIP_BIN x "$GIT_ARCHIVE" -o"./" -p"$GIT_PASSWORD" -y

  if [ $? -eq 0 ]; then
    echo "[SUCCESS] .git directory successfully extracted."
  else
    echo "[ERROR] Failed to extract .git directory."
  fi
else
  echo "[WARNING] Unauthorized MAC. .git will not be extracted."
fi
