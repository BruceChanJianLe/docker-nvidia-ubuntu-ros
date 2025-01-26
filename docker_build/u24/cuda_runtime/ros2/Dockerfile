# Ubuntu 24.04 with cuda runtime
FROM nvidia/cuda:12.5.1-runtime-ubuntu24.04

# Remove non-root ubuntu
RUN touch /var/mail/ubuntu && chown ubuntu /var/mail/ubuntu && userdel -r ubuntu

# Author Information
LABEL author "Bruce Chan Jian Le <jianle001@e.ntu.edu.sg>"
LABEL maintainer "Bruce Chan Jian Le <jianle001@e.ntu.edu.sg>"
LABEL website "https://github.com/BruceChanJianLe/docker-nvidia-ubuntu-ros"
LABEL license "MIT"

# Set Nvidia environment
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# ENVIRONMENT STUFF FOR CUDA
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/cuda/lib64
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib
ENV PATH /usr/local/cuda/bin:$PATH
ENV CUDA_ROOT /usr/local/cuda

# recommended from nvidia to use the cuda devices
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Set colorful prompt
ENV TERM xterm-256color

# Set LANG in order to display emoji
ENV LANG en_US.UTF-8
# Require for ansible
ENV LC_ALL C.UTF-8

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    build-essential \
    cmake \
    cppcheck \
    gdb \
    git \
    libbluetooth-dev \
    libcwiid-dev \
    libgoogle-glog-dev \
    libspnav-dev \
    libusb-dev \
    lsb-release \
    python3-dbg \
    python3-empy \
    python3-numpy \
    python3-setuptools \
    python3-pip \
    python3-venv \
    software-properties-common \
    sudo \
    vim \
    wget \
    net-tools \
    iputils-ping \
    libyaml-cpp-dev \
    tmux \
    curl \
    htop \
    bash-completion \
    bc \
    ansible \
    && apt-get clean -qq

# Libraries for OpenGL
RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    libglx-mesa0 \
    libgl1-mesa-dev \
    libgl1-mesa-dri \
    libglu1-mesa \
    libx11-6 \
    libglew2.2 \
    && apt-get clean -qq

# Add a user with the same user_id as the user outside of the container
# Note that this requires a docker build argument `user_id`
ARG user_id
ENV USERNAME developer
RUN useradd -U --uid ${user_id} -ms /bin/bash $USERNAME \
    && echo "$USERNAME:$USERNAME" | chpasswd \
    && adduser $USERNAME sudo \
    && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME

# Commands below are run as developer user
USER $USERNAME

# Let the container starts in the developer's home folder
WORKDIR /home/$USERNAME

# Make a mounting directory
RUN mkdir -p /home/$USERNAME/docker_mount

# Export noninterative tzdata
RUN export DEBIAN_FRONTEND=noninteractive \
 && sudo apt-get update && sudo apt-get install -y tzdata

# Install ROS2
RUN ansible-pull -U https://github.com/brucechanjianle/ansible-ros2 -e "ros2_distribution=jazzy"

# Install Gazebo Harmonic
RUN sudo apt-get install ros-jazzy-ros-gz -y

# Installing Rosdep
RUN sudo apt update -y -qq \
    && sudo DEBIAN_FRONTEND=noninteractive apt install python3-rosdep -y -qq \
    && sudo rosdep init \
    && rosdep update

# Setup dotfiles
RUN ansible-pull -U https://github.com/brucechanjianle/ansible --skip-tags additional

# Declare inside container
ENV IN_DOCKER 1

# config & cleanup
RUN sudo apt-get autoclean -y -qq \
    && sudo apt-get autoremove -y -qq \
    && sudo rm -rf /var/lib/apt/lists/* /tmp/*
