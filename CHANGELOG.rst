^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for docker-nvidia-ubuntu-ros
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

0.0.3 (2025-01-26)
------------------
- Support for u20 nvidia cuda and cuda runtime (12.5.1) [nvidia image]
- Support for u22 nvidia cuda and cuda runtime (12.5.1) [nvidia image]
- Support for u24 nvidia cuda and cuda runtime (12.5.1) [nvidia image]
- Dropping support for u18

0.0.2 (2025-01-15)
------------------
- Use non-interactive script, pass in arguement to quickly build docker images
- expose /media for contianers
- Support nvidia runtime container for smaller image size
- Support for u22 nvidia opengl (1.2glvnd) [nvidia image]
- Support for u24 nvidia cuda (12.4.1) [custom image]
- Use tag with version number, e.g. ubuntu24.04:v0.0.2-cnvros2
- Make available on docker hub, docker pull brucechanjianle/ubuntu24.04:v0.0.2-cnvros2
- Missing support for non-nvidia images and u20

0.0.1 (2023-11-12)
-------------------
- Support docker for u18 and u20 which is based on nvidia cuda (11.4) and opengl
- This version also uses the previous interactive build script
