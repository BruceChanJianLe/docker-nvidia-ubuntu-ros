#!/usr/bin/env bash

# Obtain version info
source ../.env

IMAGES=(
  # Ubuntu 20 ROS1
  "ubuntu20.04:$PACKAGE_VERSION-ros1"
  "ubuntu20.04:$PACKAGE_VERSION-cnvros1"
  "ubuntu20.04:$PACKAGE_VERSION-cnvros1-runtime"
  # Ubuntu 20 ROS2
  "ubuntu20.04:$PACKAGE_VERSION-ros2"
  "ubuntu20.04:$PACKAGE_VERSION-cnvros2"
  "ubuntu20.04:$PACKAGE_VERSION-cnvros2-runtime"
  # Ubuntu 20 ROS1 + ROS2
  "ubuntu20.04:$PACKAGE_VERSION-ros3"
  "ubuntu20.04:$PACKAGE_VERSION-cnvros3"
  "ubuntu20.04:$PACKAGE_VERSION-cnvros3-runtime"
  # Ubuntu 22 ROS2
  "ubuntu22.04:$PACKAGE_VERSION-ros2"
  "ubuntu22.04:$PACKAGE_VERSION-cnvros2"
  "ubuntu22.04:$PACKAGE_VERSION-cnvros2-runtime"
  # Ubuntu 24 ROS2
  "ubuntu24.04:$PACKAGE_VERSION-ros2"
  "ubuntu24.04:$PACKAGE_VERSION-cnvros2"
  "ubuntu24.04:$PACKAGE_VERSION-cnvros2-runtime"
)

# Define the target registry namespace
TARGET_REGISTRY="brucechanjianle"

# Initialize an empty array for tag images
TAG_IMAGES=()

# Loop through and tag images
for IMAGE in "${IMAGES[@]}"; do
  TAG_IMAGE_NAME="$TARGET_REGISTRY/$IMAGE"

  echo "Tagging $IMAGE as $TAG_IMAGE_NAME"
  docker tag "$IMAGE" "$TAG_IMAGE_NAME"

  TAG_IMAGES+=("$TAG_IMAGE_NAME")
done

printf "%s\n" "${TAG_IMAGES[@]}" | parallel -j 8 docker push {}
