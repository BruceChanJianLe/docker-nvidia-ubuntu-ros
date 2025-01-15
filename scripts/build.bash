#!/usr/bin/env bash
# This script builds the docker image

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-u] [-r] [-g] [-c]
Script description here.
Available options:
-h, --help      Print this help and exit
-u, --ubuntu    Set Ubuntu version [18/20/22/24], default 22
-r, --ros       Set ROS version ROS1 / ROS2 / (ROS1 + ROS2) [1/2/3], default 3
-g, --gpu       Set true or false for nvidia gpu capabilities, default true
-c, --cuda      Set true or false for cuda capabilities, default true

Example:
./build.bash -u 22 -r 2 -g true -c true
EOF
  exit
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  msg "Use -h for more information"
  exit "$code"
}

parse_params() {

  # Print help if no input as this is a new build script
  if test $# -eq 0 
  then
    echo "help me ob1"
    usage
  fi

  # default values of variables set from params
  UBUNTU_VERSION="22"
  ROS_VERSION="3"
  ENABLE_GPU="true"
  ENABLE_CUDA="true"
  IS_EMPTY=0

  while test $# -gt 0; do
    case $1 in
    -h | --help) usage ;;
    -u | --ubuntu)
      shift
      if [[ $1 == "18" || $1 == "20" || $1 == "22" || $1 == "24" ]]
      then
        UBUNTU_VERSION=$1
      else
        die "-u accepts [18/20/22/24]."
      fi
      ;;
    -r | --ros)
      shift
      if [[ $1 == "1" || $1 == "2" || $1 == "3" ]]
      then
        ROS_VERSION=$1
      else
        die "-r accepts ROS1 / ROS2 / (ROS1 + ROS2) [1/2/3]."
      fi
      ;;
    -g | --gpu)
      shift
      if [[ $1 == "true" || $1 == "false" ]]
      then
        ENABLE_GPU=$1
      else
        die "-g only accepts true or false."
      fi
      ;;
    -c | --cuda)
      shift
      if [[ $1 == "true" || $1 == "false" ]]
      then
        ENABLE_CUDA=$1
      else
        die "-c only accepts true or false."
      fi
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  return 0
}

parse_params "$@"

user_id=$(id -u)
if [[ $ENABLE_GPU == "true" || $ENABLE_CUDA == "true" ]]
then
  # Build with cuda nvidia
  docker build --rm -t ubuntu$UBUNTU_VERSION.04:cnvros$ROS_VERSION --build-arg user_id=$user_id -f ../docker_build/u$UBUNTU_VERSION/cudagl/ros$ROS_VERSION/Dockerfile .
else
  # Build without nvidia
  docker build --rm -t ubuntu$UBUNTU_VERSION.04:ros$ROS_VERSION --build-arg user_id=$user_id -f ../docker_build/u$UBUNTU_VERSION/non_nvidia/ros$ROS_VERSION/Dockerfile .
fi
