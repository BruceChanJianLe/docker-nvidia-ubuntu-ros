> If you would like podman the open-source alternative,
> you can refer to [podman-nvidia-ubuntu-ros](https://github.com/BruceChanJianLe/podman-nvidia-ubuntu-ros)

# Docker Nvidia Ubuntu ROS

This repository demonstrates the steps to setup docker nvidia on ubuntu with ROS in a container.

## Installing Docker and Nvidia Docker

Use ansible to quickly automate the installation of Docker and Nvidia Docker.
[Let's Go!](https://github.com/BruceChanJianLe/ansible-docker)

```bash
# For the impatient
sudo apt install ansible git -y
ansible-pull -U https://github.com/brucechanjianle/ansible-docker -K
```

> NOTICE!
> Support for U20 will be dropped in after version 0.0.4!

## Starting the Container

Run the `start.bash` in the scripts directory. Follow the instructions to get the containers running.  
Now, the images are available on [Docker Hub](https://hub.docker.com/u/brucechanjianle),
you may also build from source by following the instructions in the next section.

```bash
cd scripts
# For Ubuntu 20
./start20.bash
# For Ubuntu 22
./start22.bash
# For Ubuntu 24
./start24.bash
```

## Building from source

Update `.env` file with user id
```bash
id -u
vi .env
# user_id=1000
```

Build all images define in the `docker-compose.yaml` file.  
```bash
docker compose build
```

To build targeted image, please pass in correct service service name.  
Available tags are `uxx_cuda`, `uxx_cuda_runtime` and `uxx_non_nvidia`.  
Where xx can be 22, 24.  

```bash
docker compose build u22_cuda_runtime
```

## Viewing Docker images

Run the following commands to verify if the image is correctly built.  
```bash
docker images
# Output
# REPOSITORY          TAG                           IMAGE ID            CREATED             SIZE
# ubuntu20.04         v0.0.3-nvros                  8803ef8c8563        3 hours ago         3.32GB
```


## Restarting the Container (after reboot)

Run the `restart.bash` in the scripts directory. Follow the instructions to restart the stopped container.  
```bash
cd scripts
./restart.bash
```

## Joining the Container from A New Terminal

Run the `join.bash` in the scripts directory. Follow the instructions to join / connect to the running container.  
```bash
cd scripts
./join.bash
```
The script uses `exec` instead of `attach` as this creates another process rather than using the already existing process.  

## GPU

If you observed, the warning and error message below:  
```bash
MESA: warning: Driver does not support the 0x7d55 PCI ID.
libGL error: failed to create dri screen
libGL error: failed to load driver: iris
```

You may use the below method to offload the program to GPU:  
```bash
# __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia command
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia rviz2
```
[link](https://wiki.archlinux.org/title/PRIME)

## Error

This section are some errors observed.  

Error: during `sudo apt update` inside a container.  
```bash
Unable to mkstemp /tmp/apt-key.64EmWp.asc - GetTempFile (13: Permission denied) Couldn't create temporary file /tmp/apt.conf.M1CItx for passing config to apt-key
```

Solution:  
```bash
sudo chmod 1777 /tmp
```

## Reference
- nvidia opengl [link](https://hub.docker.com/r/nvidia/opengl)
- nvidia-docker ubuntu ros dockerfil reference [link](https://github.com/osrf/subt/blob/master/docker/subt_sim_entry/Dockerfile)
- noninteractive explanation [link](https://linuxhint.com/debian_frontend_noninteractive/)
- Gazebo 9 update [link](http://gazebosim.org/tutorials?cat=install&tut=install_ubuntu&ver=9.0)
- .docker.xauth does not exist [link](https://github.com/lbeaucourt/Object-detection/issues/7)
- using dpkg --compare-version [link](https://mike632t.wordpress.com/2017/03/02/compairing-version-numbers-using-dpkg/)
- xhost command [link](https://unix.stackexchange.com/questions/177557/what-does-this-xhost-command-do)
- docker env COLUMNS and LINES reason [link](https://codeslake.github.io/ubuntu/installation/when-terminal-created-from-docker-exec-has-strange-behaviour-abnormal-size-command-vanishing/)
```bash
 docker exec --privileged -e DISPLAY=${DISPLAY} -e COLUMNS=`tput cols` -e LINES=`tput lines` -ti ${arr[$CONTAINERNAME]} bash
```
- symbol lookup error: /usr/lib/x86_64-linux-gnu/libgazebo_common.so.9 [link](https://answers.gazebosim.org//question/22071/symbol-lookup-error-both-instalation-methods/)
- exec vs attach [link](https://stackoverflow.com/questions/30960686/difference-between-docker-attach-and-docker-exec)
- opengl non nvidia [link1](https://medium.com/@benjamin.botto/opengl-and-cuda-applications-in-docker-af0eece000f1) [link2](https://github.com/utensils/docker-opengl)
