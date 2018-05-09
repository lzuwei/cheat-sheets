#!/bin/sh
sudo apt-get install libboost-dev
sudo apt-get install libevent-dev automake libtool flex bison pkg-config g++ libssl-dev 
cd /tmp 
curl http://archive.apache.org/dist/thrift/0.9.2/thrift-0.9.2.tar.gz | tar zx 
cd thrift-0.9.2/ 
./configure 
make 
sudo make install 
thrift --help 
