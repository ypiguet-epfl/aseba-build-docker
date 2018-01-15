# Download and build Aseba .deb
# Usage:
# To build the image (ubuntu, build tools and libraries, aseba, build):
#  sudo docker build -t aseba-linux-build .
# To get a shell with /host mapped to the current directory on the host
# (then deb packages can be copied to host with "cp *.deb /host"):
#  sudo docker run -it -v `pwd`:/host aseba-linux-build

FROM ubuntu

LABEL author="Yves Piguet"
LABEL version="2018-Jan-13"
LABEL description="Build debian packages for Aseba, Dashel and Enki in Ubuntu"
LABEL url="https://github.com/aseba-community"

ADD build.sh build.sh
RUN chmod +x build.sh

# update image, download Aseba and build everything
RUN ./build.sh prepare
RUN ./build.sh get
RUN ./build.sh build
RUN ./build.sh deb
