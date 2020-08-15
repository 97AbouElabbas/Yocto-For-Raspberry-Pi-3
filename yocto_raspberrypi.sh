#!/bin/bash

#########################################################
###                                                   ###
###       Yocto installation steps in raspberry       ###
###                                                   ###
#########################################################


### variables

BASE=$(pwd -P)

### Check empty directory

if [ "$(/bin/ls -1A | wc -l)" -ne "3" ]; then
    echo Please run this script from an empty directory.
    exit 1
fi

### Install packages needed by Yocto

sudo apt-get update
sudo apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping libsdl1.2-dev xterm


### Clone Yocto layers
git clone -b zeus git://git.yoctoproject.org/poky.git ${BASE}/src/poky
git clone -b zeus git://git.openembedded.org/meta-openembedded ${BASE}/src/meta-openembedded
git clone -b zeus git://git.yoctoproject.org/meta-raspberrypi ${BASE}/src/meta-raspberrypi
#git clone -b master https://github.com/AbdelrahmanAAli/Yocto-For-Raspberry-Pi-3.git ${BASE}/src/Yocto-For-Raspberry-Pi-3

### Create the base build directory (local.conf & bblayer.conf)

mkdir ${BASE}/build
source ${BASE}/src/poky/oe-init-build-env ${BASE}/build

bitbake-layers add-layer ${BASE}/src/meta-raspberrypi
bitbake-layers add-layer ${BASE}/src/meta-openembedded/meta-oe
bitbake-layers add-layer ${BASE}/src/meta-openembedded/meta-python
bitbake-layers add-layer ${BASE}/src/meta-openembedded/meta-multimedia
bitbake-layers add-layer ${BASE}/src/meta-openembedded/meta-networking

#cp ${BASE}/src/Yocto-For-Raspberry-Pi-3/local.conf ${BASE}/build/conf
cp ${BASE}/local.conf ${BASE}/build/conf

# Cui Build Image
bitbake rpi-basic-image

