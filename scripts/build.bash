#!/usr/bin/env bash
# This script builds the docker image

# Obtain Ubuntu version
read -p "Select the Ubuntu version you wish to build upon[18/20]:" version

if [[ $version == 18 ]]
then
    # Cuda selection
    read -p "Do you want to have cuda for your Ubuntu18.04?[Y/n]" value

    # Verify cuda check
    if [[ -z $value || $value == y || $value == Y ]]
    then
        user_id=$(id -u)
        docker build --rm -t "ubuntu18.04:cnvros" --build-arg user_id=$user_id -f ../docker_build/u18/cuda/Dockerfile .
    else
        # To build or not to build
        read -p "This script will build docker image ubuntu18.04:nvros continue[Y/n]? " value

        # Verify build check
        if [[ -z $value || $value == y || $value == Y ]]
        then
            user_id=$(id -u)
            docker build --rm -t "ubuntu18.04:nvros" --build-arg user_id=$user_id -f ../docker_build/u18/Dockerfile .
        else
            exit 1
        fi
    fi
elif [[ $version == 20 ]]
then
    # To build or not to build
    read -p "This script will build docker image ubuntu20.04:nvros contunue[Y/n]? " value

    # Verify build check
    if [[ -z $value || $value == y || $value == Y ]]
    then
        # Select which version of ROS
        read -p "Select ROS1 or ROS2[1/2]? " value
        if [[ -z $value || $value == 1 ]]
        then
            user_id=$(id -u)
            docker build --rm -t ubuntu20.04:nvros1 --build-arg user_id=$user_id -f ../docker_build/u20/ros1/Dockerfile .
        elif [[ $value == 2 ]]
        then
            user_id=$(id -u)
            docker build --rm -t ubuntu20.04:nvros2 --build-arg user_id=$user_id -f ../docker_build/u20/ros2/Dockerfile .
        else
            echo "Invalid selection, nothing will be built."
        fi
    else
        exit 1
    fi
else
    # Ubuntu version not supported
    echo -e "The Ubuntu version you have selected "$version" is currently not supported."
fi
