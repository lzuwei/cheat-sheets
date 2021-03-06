#!/bin/sh

sudo apt-get install scons
git clone https://github.com/mongodb/mongo-cxx-driver.git

#checkout the stable 2.6 drivers
cd mongo-cxx-driver
git checkout 26compat

#compile the drivers
sudo scons --full --use-system-boost --sharedclient install-mongoclient

#for macosx 10.10 and above
sudo scons --full --use-system-boost --sharedclient --osx-version-min=10.10 install-mongoclient
