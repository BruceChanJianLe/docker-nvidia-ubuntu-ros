# Ubuntu 20.04 with nvidia-docker2 (cuda + openGL)
FROM nvidia/cudagl:11.4.0-devel-ubuntu20.04

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

# Export noninterative
RUN export DEBIAN_FRONTEND=noninteractive \
 && sudo apt-get update -qq \
 && sudo -E apt-get install -y -qq \
    tzdata \
 && echo 'Etc/UTC' > sudo tee /etc/timezone \
 && sudo ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime \
 && sudo dpkg-reconfigure --frontend noninteractive tzdata \
 && sudo apt-get clean -qq

# Install ROS2
RUN sudo apt update -y -qq \
    && sudo apt upgrade -y -qq \
    && sudo apt install locales -y -qq \
    && sudo locale-gen en_US en_US.UTF-8 \
    && sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && export LANG=en_US.UTF-8 \
    && sudo apt install software-properties-common -y -qq \
    && sudo add-apt-repository universe \
    && sudo apt update -y -qq && sudo apt install curl gnupg lsb-release -y -qq \
    && sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN sudo /bin/bash -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null'

RUN sudo apt update -y -qq \
    && sudo apt upgrade -y -qq \
    && sudo DEBIAN_FRONTEND=noninteractive apt install ros-galactic-desktop -y -qq

# Update Gazebo 11
RUN sudo /bin/bash -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
    && wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add - \
    && sudo apt-get update -qq \
    && sudo apt-get install -y -qq \
    gazebo11 \
    && sudo apt-get upgrade -y -qq

# Source ROS2
RUN echo "\nalias gazebokill='killall -9 gazebo & killall -9 gzserver & killall -9 gzclient'" >> ~/.bashrc \
    && echo "\nalias roskill='for i in $(pgrep -f melodic); do kill $i; done'" >> ~/.bashrc \
    && echo "\nalias ross2='. ~/.ros2_env'" >> ~/.bashrc
# 
RUN touch ~/.ros2_env \
    && echo "source /opt/ros/galactic/setup.bash" >> ~/.ros2_env
 
# Installing Colcon
RUN sudo /bin/sh -c 'echo "deb [arch=amd64,arm64] http://repo.ros2.org/ubuntu/main `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list' \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add - \
    && sudo apt update -y -qq \
    && sudo apt install -y -qq python3-colcon-common-extensions

RUN echo "\nsource /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.ros2_env \
    && echo "\nsource /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.ros2_env

# Installing Rosdep
RUN sudo apt update -y -qq \
    && sudo DEBIAN_FRONTEND=noninteractive apt install python3-rosdep -y -qq \
    && sudo rosdep init \
    && rosdep update

# Setup tmux and vim
RUN curl -o ~/.tmux.conf https://raw.githubusercontent.com/BruceChanJianLe/TMUX_Setup/master/.tmux.conf \
        && curl https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux > ~/.bash_completion \
        && echo "source ~/.bash_completion" >> ~/.bashrc \
        && curl -o ~/.vimrc https://raw.githubusercontent.com/BruceChanJianLe/vim/master/.vimrc \
        && git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell \
        && echo "\n# Base16 Shell" >> ~/.bashrc \
        && echo "BASE16_SHELL=\"\$HOME/.config/base16-shell/\"" >> ~/.bashrc \
        && echo "[ -n \"\$PS1\" ] && \\"  >> ~/.bashrc \
        && echo "    [ -s \"\$BASE16_SHELL/profile_helper.sh\" ] && \\"  >> ~/.bashrc \
        && echo "        eval \"\$(\"\$BASE16_SHELL/profile_helper.sh\")\"" >> ~/.bashrc

RUN sudo apt install -y -qq xsel xclip

# Setup color prompt and git
RUN echo "\nparse_git_branch() {\n git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\\\1)/'\n}" >> ~/.bashrc \
        && echo "\nPS1='🐳\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]\$(parse_git_branch)\[\033[00m\]\$ '" >> ~/.bashrc \
        && sed -ie 's|#    . /etc/bash_completion|. /etc/bash_completion|g' ~/.bashrc 

# Setup Vim
RUN mkdir -p ~/.vim/undodir \
        && curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN vim +PlugInstall +qa

# config & cleanup
RUN sudo apt-get autoclean -y -qq \
    && sudo apt-get autoremove -y -qq \
    && sudo rm -rf /var/lib/apt/lists/* /tmp/*

# Run colorful prompt
CMD ["/bin/bash", "-l" ]
