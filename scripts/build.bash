#!/usr/bin/env bash
# This script builds the docker image

read -p "This script will build docker image ubuntu18.04:nvros continue[Y/n]?" value

if [[ -z $value || $value == y || $value == Y ]]
then
    user_id=$(id -u)
    docker build --rm -t "ubuntu18.04:nvros" --build-arg user_id=$user_id -f ../docker_build/Dockerfile .
else
    exit 1
fi