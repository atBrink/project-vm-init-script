#!/bin/sh
# If any errors occur check 
# https://github.com/UZ-SLAMLab/ORB_SLAM3/issues 
# or
# https://github.com/raulmur/ORB_SLAM2/issues
# for two sources of very comprehensive answers, since most errors would occur from building orb-slam or their dependensies.
# Another cause for error might be openssl, which case you can also check out: https://cloudwafer.com/blog/installing-openssl-on-ubuntu-16-04-18-04/
# create project folder with *optional-input-argument-name* in the home directory:
projectFolderName=${1:-orb_slam_project}

if [ ! -d $projectFolderName ]; then
  mkdir -p $projectFolderName;
  echo "Created folder: $projectFolderName"
fi

# update this link to latest openssl version
latestOpenSSL='https://www.openssl.org/source/openssl-1.1.1k.tar.gz'

# Depending on OS version and orb-slam version, different openCV might be used, for ubuntu 18.04 & orb-slam3 3.4 was verified, and thus used here.
opencvVersion='https://github.com/opencv/opencv/archive/3.4.13.zip'

# Update system packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install packages
sudo apt install cmake g++ wget unzip git build-essential checkinstall zlib1g-dev -y

###### Download git repos etc: ###########
cd ~
mkdir $projectFolderName && cd $projectFolderName

# ORB-SLAM3
git clone https://github.com/UZ-SLAMLab/ORB_SLAM3.git ORB_SLAM3
# PANGOLIN:
git clone https://github.com/stevenlovegrove/Pangolin.git

# Opencv:
# Create opencv folder
mkdir -p opencv && cd opencv
wget -O opencv.zip $opencvVersion
unzip opencv.zip && rm opencv.zip -y

### OPENSSL: #####
cd /usr/local/src/
sudo wget -c $latestOpenSSL -O openssl.tar.gz
# extract openssl-archive and rename the folder to openssl-dir
sudo tar xf openssl.tar.gz --transform 's!^[^/]\+\($\|/\)!openssl-dir\1!' && rm openssl.tar.gz

## Download Datasets:
cd ~/$projectFolderName
mkdir Datasets && cd Datasets

# Kitti sequences & ground truth:
mkdir KITTI && cd KITTI
wget https://s3.eu-central-1.amazonaws.com/avg-kitti/data_odometry_gray.zip
wget https://s3.eu-central-1.amazonaws.com/avg-kitti/data_odometry_poses.zip
unzip data_odometry_gray.zip && rm data_odometry_gray.zip
unzip data_odometry_poses.zip  && rm data_odometry_poses.zip

# EuRoC Machine-hall 01 and Vicon Room 01 (https://projects.asl.ethz.ch/datasets/doku.php?id=kmavvisualinertialdatasets):
cd ~/$projectFolderName/Datasets
mkdir EuRoC && cd EuRoC
mkdir MH01 && cd MH01
wget http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/machine_hall/MH_01_easy/MH_01_easy.zip
unzip MH_01_easy.zip && rm MH_01_easy.zip
cd ..

mkdir VR101 && cd V101
wget http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/vicon_room1/V1_01_easy/V1_01_easy.zip
unzip V1_01_easy.zip && rm V1_01_easy.zip

cd ~

###### ORB-SLAM3 ##########
# Prerequisites & nested Prerequisits:

# Pangolin & Prerequisits: (https://github.com/stevenlovegrove/Pangolin)

# OpenGL: (Required for Pangolin)
sudo apt install libgl1-mesa-dev -y

# Glew:  (Required for Pangolin)
sudo apt install libglew-dev -y

# Python 2.7 (Recommended for Pangolin)
sudo apt install libpython2.7-dev -y

# Wayland: (Recommended for Pangolin)
sudo apt install pkg-config -y

# Install libgtk2.0 (opencv prereq)
sudo apt-get install libgtk2.0-dev -y

### Eigen3 (https://github.com/roboticslab-uc3m/installation-guides/blob/master/install-eigen.md)
sudo apt install libeigen3-dev -y

## Boost (Dependancy of DBoW2)
sudo apt-get install libboost-all-dev -y

sudo apt-get update && sudo apt-get upgrade -y

# install Pangolin
cd ~/$projectFolderName/Pangolin
mkdir build
cd build
cmake ..
cmake --build .

#### OPENCV #############
cd ~/$projectFolderName/opencv
# Create build directory
mkdir -p build && cd build
# Configure
# cmake  ../opencv-master
cmake ../opencv-3.4.13
# Build
cmake --build .

# install
sudo make install

# Return to root folder
cd ~

## Openssl (Dependancy) (https://cloudwafer.com/blog/installing-openssl-on-ubuntu-16-04-18-04/)
sudo apt-get update && sudo apt-get upgrade

cd /usr/local/src/openssl-dir
sudo ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib
sudo make
sudo make test
sudo make install

cd /etc/ld.so.conf.d/
sudo echo "/usr/local/ssl/lib" > openssl.conf
sudo ldconfig -v

# Create backup files:
sudo mv /usr/bin/c_rehash /usr/bin/c_rehash.backup
sudo mv /usr/bin/openssl /usr/bin/openssl.backup

sudo echo PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/ssl/bin" > /etc/environment
source /etc/environment

cd ~/$projectFolderName
sudo apt-get update && sudo apt-get upgrade -y

cd ORB_SLAM3
chmod +x build.sh
./build.sh
