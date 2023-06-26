#!/usr/bin/env bash
# This script setup hardlinks for docker containers as udev does not work
# WARNING #
# Run this script before starting/restarting a container

# Verify hardlink docker dir exist
cd /dev/
if [[ ! -d "docker" ]]; then
  sudo mkdir docker
fi

# Files to create hardlinks
HLINKS=(
  "bms_battery"
  "bms_charger"
  "sam_controller"
  "motor_controller"
)

SLINKS=$(find . -type l -ls)


for STR in ${HLINKS[@]}; do
  if [[ ! -c "docker/$STR" ]]; then
    find . -type l -ls | grep $STR &> /dev/null
    if [[ $? = 0 ]]; then
      THE_LINK=$(find . -type l -ls | grep $STR | awk '{print $NF}')
      sudo ln $THE_LINK docker/$STR
      echo "Successful created hardlink for "$STR
    else
      echo "Failed to creat hardlink for "$STR
    fi
  else
    echo "Skipping hardlink for "$STR" as it already exist."
  fi
done

