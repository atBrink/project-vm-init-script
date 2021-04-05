project-vm-init-script

Simple shell-script made to install all the necessary packages, codebases and datasets on a fresh Virtual-Machine for our thesis-project.

Requires Root!

Change openssl-version on line 17 to newest version.
Optional input argument to name a top-folder name to download everything to.

# Packages:
* Updates system packages,
* cmake 
* g++ 
* wget 
* unzip 
* git 
* build 
* checkinstall 
* zlib1g
* libgl1-mesa
* libglew
* libpython2.7
* pkg-config
* libgtk2.0
* libeigen3
* libboost-all
* openssl

# Datasets:
KITTI odometry data & ground truth,
two datasets from EuRoC

# git repos:
Orb-slam3
Pangolin
openCV

