#bare setup
FROM ubuntu:18.04
RUN apt-get update && apt-get upgrade -y && apt install wget -y
RUN ["apt-get", "install", "-y", "vim"]
RUN apt-get install net-tools
RUN apt install git -y
RUN apt-get install build-essential cmake git -y
RUN apt install curl
ARG DEBIAN_FRONTEND=noninteractive

#scylla driver
RUN apt-get install libuv1.dev
RUN apt-get install libssl-dev
RUN mkdir irmin-scylla
WORKDIR ./irmin-scylla/
RUN git clone https://github.com/ssdubey/libraries.git
WORKDIR ./libraries/irmin-master/src/libcassandra/cpp-driver
RUN mkdir build
RUN pushd build
RUN cmake ..
RUN make
RUN make install
RUN popd

#installing scylla
curl -o /etc/apt/sources.list.d/scylla.list -L http://repositories.scylladb.com/scylla/repo/94f62ae3-64f9-421f-a500-c8bcbe5a803e/ubuntu/scylladb-3.3-bionic.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5E08FBD8B5D6EC9C
apt-get update
apt-get install scylla -y
scylla_dev_mode_setup --developer-mode 1
CMD /bin/bash



# This is getting stuck at sarting the scylla server due to systemctl not accessible issue
# Not required this setup as I can work with docker based scylla servers