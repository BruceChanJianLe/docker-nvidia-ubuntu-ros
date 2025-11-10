# Ubuntu 20.04 non-nvidia (ros1 and ros2)
FROM ros:noetic-ros-base-focal

# Author Information
LABEL author="Bruce Chan Jian Le <jianle001@e.ntu.edu.sg>"
LABEL maintainer="Bruce Chan Jian Le <jianle001@e.ntu.edu.sg>"
LABEL website="https://github.com/BruceChanJianLe/docker-nvidia-ubuntu-ros"
LABEL license="MIT"

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
    && sudo DEBIAN_FRONTEND=noninteractive apt install ros-foxy-desktop ros-galactic-desktop -y -qq

# Source ROS2 Galactic
RUN echo "\n alias gzkill='pkill -f gzclient; pkill -f gzserver; pkill -f gazebo'" >> ~/.bashrc \
    && echo "\nalias roskill='for i in \$(pgrep -f ros/\$ROS_DISTRO); do kill \$i; done'" >> ~/.bashrc \
    && echo "\nalias galactic='. ~/.galactic_env'" >> ~/.bashrc \
    && echo "\nalias foxy='. ~/.foxy_env'" >> ~/.bashrc

RUN touch ~/.galactic_env \
    && echo "source /opt/ros/galactic/setup.bash" >> ~/.galactic_env
 
RUN touch ~/.foxy_env \
    && echo "source /opt/ros/foxy/setup.bash" >> ~/.foxy_env

# Installing Colcon
RUN sudo /bin/sh -c 'echo "deb [arch=amd64,arm64] http://repo.ros2.org/ubuntu/main `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list' \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add - \
    && sudo apt update -y -qq \
    && sudo apt install -y -qq python3-colcon-common-extensions

RUN echo "source /usr/share/gazebo/setup.sh" >> ~/.galactic_env \
    && echo "\nsource /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.galactic_env \
    && echo "\nsource /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.galactic_env

RUN echo "source /usr/share/gazebo/setup.sh" >> ~/.foxy_env \
    && echo "\nsource /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.foxy_env \
    && echo "\nsource /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.foxy_env

# Installing Rosdep
RUN sudo apt update -y -qq \
    && rosdep update

# Source ROS1
RUN echo "\nalias ross='. ~/.ros_env'" >> ~/.bashrc
RUN touch ~/.ros_env \
    && echo "source /opt/ros/noetic/setup.bash" >> ~/.ros_env

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
        && echo "        source \"\$BASE16_SHELL/profile_helper.sh\"" >> ~/.bashrc

RUN sudo apt install -y -qq xsel xclip

# Setup color prompt and git
RUN echo "\nparse_git_branch() {\n git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\\\1)/'\n}" >> ~/.bashrc \
        && echo "\nPS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u\[\033[01;36m\]U20🐳\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]\$(parse_git_branch)\[\033[00m\]\$ '" >> ~/.bashrc \
        && sed -ie 's|#    . /etc/bash_completion|. /etc/bash_completion|g' ~/.bashrc 

# Setup Vim
RUN mkdir -p ~/.vim/undodir \
        && curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN vim +PlugInstall +qa

# config & cleanup
RUN sudo apt-get clean -y -qq \
    && sudo apt-get autoremove -y -qq \
    && sudo rm -rf /var/lib/apt/lists/* /tmp/*

# Run colorful prompt
CMD ["/bin/bash", "-l" ]
