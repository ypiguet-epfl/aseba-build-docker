# aseba-build-docker

Dockerfile and support files to build Aseba in docker in the Ubuntu environment. Runs on any platform supported by docker.

## Usage

To build the image (ubuntu, build tools and libraries, source code downloaded from github, build):

	sudo docker build -t aseba-linux-build .

To get a shell with /host mapped to the current directory on the host (then deb packages can be copied to host with "cp *.deb /host"):

	sudo docker run -it -v `pwd`:/host aseba-linux-build

Once you're in the docker shell (as root), you can modify the source code and run parts of the build process by running the build script manually:

	./build.sh help

Type `exit` or ctrl-d to exit the docker shell.

## Reference

The build script is based on instructions at https://github.com/aseba-community/aseba/blob/master/compile.Linux.md
