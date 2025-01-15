# Ubuntu 24.04 with nvidia-docker2 (CUDA) OpenGL version not available
# FROM nvidia/cuda:12.6.3-cudnn-runtime-ubuntu24.04
FROM nvidia/cuda:12.5.1-runtime-ubuntu24.04

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

# Dynamically assign a UID by choosing the next available UID
RUN user_id=$(($(getent passwd | awk -F: '{print $3}' | sort -n | tail -n 1) + 1))
ENV USERNAME developer
RUN useradd -U --uid ${user_id} -ms /bin/bash $USERNAME
RUN echo "$USERNAME:$USERNAME" | chpasswd
RUN adduser $USERNAME sudo
RUN echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME

# Commands below are run as developer user
USER $USERNAME

# Let the container starts in the developer's home folder
WORKDIR /home/$USERNAME

# Make a mounting directory
RUN mkdir -p /home/$USERNAME/docker_mount

# Export noninterative
RUN export DEBIAN_FRONTEND=noninteractive \
 && export TZ=Etc/UTC \
 && sudo ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime \
 && sudo -E apt-get update -qq \
 && sudo -E apt-get install -y -qq --no-install-recommends tzdata \
 && sudo -E dpkg-reconfigure --frontend noninteractive tzdata \
 && sudo -E apt-get clean -qq

# Install language
RUN sudo apt-get update -qq \
 && sudo apt-get install -y -qq locales \
 && sudo locale-gen en_US.UTF-8 \
 && sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Set the LANG environment variable for the container
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Install ROS2
# RUN ansible-pull -U https://github.com/brucechanjianle/ansible-ros2 -e "ros2_distribution=jazzy"

# Install Gazebo 11
# RUN sudo apt-get install gazebo -y -qq

# Installing Rosdep
# RUN sudo apt update -y -qq \
#     && sudo DEBIAN_FRONTEND=noninteractive apt install python3-rosdep -y -qq \
#     && sudo rosdep init \
#     && rosdep update

# Setup dotfiles
RUN ansible-pull -U https://github.com/brucechanjianle/ansible -C u24

# Declare inside container
ENV IN_DOCKER 1

# config & cleanup
RUN sudo apt-get autoclean -y -qq \
    && sudo apt-get autoremove -y -qq \
    && sudo rm -rf /var/lib/apt/lists/* /tmp/*

# Run colorful prompt
CMD ["/bin/bash", "-l" ]

