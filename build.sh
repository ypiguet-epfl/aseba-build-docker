#!/bin/sh
# Yves Piguet, Jan 2018
# Usage: ./build.sh help
# Public domain, no warranty of any kind

# directory where everything is downloaded and built
BASE=aseba

case "$1" in

help)
cat <<eof
build.sh -- helper script to download and build Aseba
Usage (if non-root, prefix with "sudo "):
To update Ubuntu
  ./build.sh prepare
To download Aseba, Dashel and Enki
  ./build.sh get
To compile everything
  ./build.sh build
To compile only dashel
  ./build.sh build dashel
To compile only enki
  ./build.sh build enki
To compile only aseba
  ./build.sh build aseba
To make deb packages
  ./build.sh deb
eof
;;

prepare)
apt-get update
# packages for build
apt-get install -y libqt4-dev libqtwebkit-dev qt4-dev-tools libqwt5-qt4-dev libudev-dev libxml2-dev libsdl2-dev libavahi-compat-libdnssd-dev cmake g++ git make build-essential devscripts equivs libjs-jquery
# packages for deb dashel
apt-get install -y libjs-jquery
# packages for deb enki
apt-get install -y libboost-python-dev libboost-python1.58-dev libboost-python1.58.0 libboost1.58-dev libexpat1-dev libpython-dev libpython2.7 libpython2.7-dev python-dev python2.7-dev
# packages for further development
apt-get install -y vim
;;

get)
mkdir -p $BASE
(cd $BASE; git clone https://github.com/aseba-community/dashel.git; git clone https://github.com/enki-community/enki.git; git clone --recursive https://github.com/aseba-community/aseba.git)
;;

build)
case "$2" in
dashel)
(mkdir -p $BASE/build-dashel; cd $BASE/build-dashel; cmake ../dashel -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_SHARED_LIBS=OFF; make)
;;
enki)
(mkdir -p $BASE/build-enki; cd $BASE/build-enki; cmake ../enki -DCMAKE_BUILD_TYPE=RelWithDebInfo; make; make install)
;;
aseba)
(mkdir -p $BASE/build-aseba; cd $BASE/build-aseba; cmake ../aseba -DCMAKE_BUILD_TYPE=RelWithDebInfo -Ddashel_DIR=../build-dashel -Denki_DIR=../build-enki; make; make install)
;;
*)
"$0" build dashel
"$0" build enki
"$0" build aseba
;;
esac
;;

deb)
(cd $BASE/dashel; mk-build-deps -i; debuild -i -us -uc -b)
(cd $BASE; dpkg -i libdashel*.deb)
(cd $BASE/enki; mk-build-deps -i; debuild -i -us -uc -b)
(cd $BASE; dpkg -i libenki*.deb)
(cd $BASE/aseba; mk-build-deps -i; debuild -i -us -uc -b)
;;

*)
echo "Unknown or missing option. To learn more, please type $0 help"
;;

esac
