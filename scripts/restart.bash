#!/usr/bin/env bash
# This script restarts an exited container

# Requirement:
# - docker
# - nvidia-docker2
# - x server

# Remove previous docker xauth
sudo rm -rf /tmp/.docker.xauth
if [ $? ]; then
  exit -1
fi

# Display all container's name
echo "List of containers:"
declare -a arr
i=0

# Place container's name into the array
containers=$(docker ps -a | awk '{if(NR>1) print$NF}')
for container in $containers
do
    arr[$i]=$container
    let "i+=1"
done

# Display container's name through looping the array
let "i-=1"
for j in $(seq 0 $i)
do
    echo $j")" ${arr[$j]}
done

# Allowing container to connect to x server (for gazebo)
XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist $DISPLAY)
    xauth_list=$(sed -e 's/^..../ffff/' <<< "$xauth_list")
    if [ ! -z "$xauth_list" ]
    then
        echo "$xauth_list" | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

# Prevent executing "docker run" when xauth failed.
if [ ! -f $XAUTH ]
then
  echo "[$XAUTH] was not properly created. Exiting..."
  exit 1
fi

# Obtain container's name
read -p "Container number to be restarted: " CONTAINERNAME

if [[ -z ${arr[$CONTAINERNAME]} ]]
then
    exit 1
else
    docker start ${arr[$CONTAINERNAME]}
fi
