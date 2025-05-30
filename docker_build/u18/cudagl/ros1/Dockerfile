# Ubuntu 18.04 with nvidia-docker2 (opengl)
FROM nvidia/cudagl:11.4.0-devel-ubuntu18.04

# Author Information
LABEL author="Bruce Chan Jian Le <jianle001@e.ntu.edu.sg>"
LABEL maintainer="Bruce Chan Jian Le <jianle001@e.ntu.edu.sg>"
LABEL website="https://github.com/BruceChanJianLe/docker-nvidia-ubuntu-ros"
LABEL license="MIT"

# Set Nvidia environment
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# ENVIRONMENT STUFF FOR CUDA
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/cuda/lib64
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib
ENV PATH=/usr/local/cuda/bin:$PATH
ENV CUDA_ROOT /usr/local/cuda

# recommended from nvidia to use the cuda devices
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Set colorful prompt
ENV TERM xterm-256color

# Set LANG in order to display emoji
ENV LANG en_US.UTF-8
# Require for ansible
ENV LC_ALL C.UTF-8

# Export noninterative
RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get update \
&& apt-get install --no-install-recommends -y \
tzdata \
&& ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime \
&& dpkg-reconfigure --frontend noninteractive tzdata \
&& apt-get clean -qq \
&& apt-get install --no-install-recommends -y keyboard-configuration \
&& dpkg-reconfigure --frontend noninteractive keyboard-configuration \
&& apt-get clean -qq

# Useful tools for development
RUN apt-get update -qq \
    && apt-get install -y -qq \
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
    ruby2.5 \
    ruby2.5-dev \
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

# Install ROS 
RUN sudo /bin/sh -c 'echo "deb [trusted=yes] http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add - \
    && sudo apt-get update -qq \
    && sudo apt-get install -y -qq \
    ros-melodic-desktop-full \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    && sudo rosdep init \
    && sudo apt-get clean -qq

# ROS DEP update
RUN rosdep update

# Update Gazebo 9
RUN sudo /bin/sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
    && wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add - \
    && sudo apt-get update -qq \
    && sudo apt-get install -y -qq \
    gazebo9 \
    && sudo apt-get upgrade -y -qq \
    && sudo apt-get upgrade libignition-math2 -y -qq 

# Setup dotfiles
RUN ansible-pull -U https://github.com/brucechanjianle/ansible -e "dotfile_branch=docker" -v -C u18

# Declare inside container
ENV IN_DOCKER 1

# config & cleanup
RUN sudo apt-get autoclean -y -qq \
    && sudo apt-get autoremove -y -qq \
    && sudo rm -rf /var/lib/apt/lists/* /tmp/*

# Run colorful prompt
CMD ["/bin/bash", "-l" ]
