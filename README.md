# Docker Nvidia Ubuntu ROS

This repository demonstrates the steps to setup docker nvidia on ubuntu with ROS in a container.  

## Building the Dockerfile

Run the `build.bash` in the scripts directory. Follow the instructions to build the docker image.  
```bash
cd scripts
./build.bash
```

## Viewing Docker images

Run the following commands to verify if the image is correctly built.  
```bash
docker images
# Output
# REPOSITORY          TAG                           IMAGE ID            CREATED             SIZE
# ubuntu18.04         nvros                         8803ef8c8563        3 hours ago         3.32GB
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
- symbol lookup error: /usr/lib/x86_64-linux-gnu/libgazebo_common.so.9 [link](https://answers.gazebosim.org//question/22071/symbol-lookup-error-both-instalation-methods/)