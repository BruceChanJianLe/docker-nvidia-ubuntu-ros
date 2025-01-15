#!/usr/bin/env bash
# This script joins this terminal to specific docker container

# Display all container's name
echo "List of containers:"
declare -a arr
i=0

# Make container name into an array
containers=$(docker ps -a | grep Up | awk '{print$NF}')
if [[ -z $containers ]]
then
  echo "  - No running containers found, to start/restart a container, use the start/restart scripts."
  exit 0
else
  for container in $containers
  do
    arr[$i]=$container
    let "i+=1"
  done
fi

# Loop through name array
let "i-=1"
for j in $(seq 0 $i)
do
    echo $j")" ${arr[$j]}
done

# Obtain container name
read -p "Container name to be connected: " CONTAINERNAME
read -p "Join with Bash / Zsh? [B/z] " value

if [[ -z $value || $value == b || $value == B ]]
then
    DOCKER_SHELL=bash
else
    DOCKER_SHELL=zsh
fi

if [[ -z ${arr[$CONTAINERNAME]} ]]
then
    docker exec --privileged -e DISPLAY=${DISPLAY} -ti $CONTAINERNAME $DOCKER_SHELL
else
    docker exec --privileged -e DISPLAY=${DISPLAY} -ti ${arr[$CONTAINERNAME]} $DOCKER_SHELL
fi
