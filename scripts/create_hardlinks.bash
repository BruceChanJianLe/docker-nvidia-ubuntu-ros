#!/usr/bin/env bash
# This script setup hardlinks for docker containers as udev does not work
# ATTENTION: Run this script before starting/restarting a container

# For consistency, all hardlinks are inside /dev/docker
# Verify hardlink docker dir exist
cd /dev/
if [[ ! -d "docker" ]]; then
  sudo mkdir docker
fi

# Create hardlinks based on symbolic links from udev
HLINKS=(
  "sonar"
  "/input/joywireless"
)

for STR in ${HLINKS[@]}; do
  # Skip if link already exist
  if [[ ! -c "docker/$STR" ]]; then
    find . -type l -ls | grep $STR &> /dev/null
    if [[ $? = 0 ]]; then
      THE_LINK=$(find . -type l -ls | grep $STR | awk '{print $NF}')
      sudo ln $THE_LINK docker/$STR
      echo "Successful created hardlink for "$STR
    else
      # Symbolic link may not exist
      echo "Failed to find "$STR" for hardlink creation."
    fi
  else
    echo "Skipping hardlink for "$STR" as it already exist."
  fi
done

