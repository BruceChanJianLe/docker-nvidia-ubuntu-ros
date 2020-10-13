#!/usr/bin/env bash
# This script builds the docker image

# Obtain Ubuntu version
read -p "Select the Ubuntu version you wish to build upon[18/20]:" version

if [[ $version == 18 ]]
then
    # To build or not to build
    read -p "This script will build docker image ubuntu18.04:nvros continue[Y/n]?" value

    # Verify build check
    if [[ -z $value || $value == y || $value == Y ]]
    then
        user_id=$(id -u)
        docker build --rm -t "ubuntu18.04:nvros" --build-arg user_id=$user_id -f ../docker_build/u18/Dockerfile .
    else
        exit 1
    fi
elif [[ $version == 20 ]]
then
    # To build or not to build
    read -p "This script will build docker image ubuntu20.04:nvros contunue[Y/n]?" value

    # Verify build check
    if [[ -z $value || $value == y || $value == Y ]]
    then
        user_id=$(id -u)
        docker build --rm -t ubuntu20.04:nvros --build-arg user_id=$user_id -f ../docker_build/u20/Dockerfile .
    else
        exit 1
    fi
else
    # Ubuntu version not supported
    echo -e "The Ubuntu version you have selected "$version" is currently not supported."
fi
