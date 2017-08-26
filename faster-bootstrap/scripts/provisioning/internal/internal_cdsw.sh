#!/bin/sh

sudo yum -y update

# CDSW
sudo yum -y install dnsmasq

## CDSW GPU
cd /tmp
sudo yum -y groupinstall "Development tools"
sudo yum -y install kernel-devel-`uname -r`

cat << __EOF__ > cloudera-cdsw.repo
[cloudera-cdsw]
# Packages for Cloudera's Distribution for data science workbench, Version 1, on RedHat	or CentOS 7 x86_64
name=Cloudera's Distribution for cdsw, Version 1
baseurl=https://archive.cloudera.com/cdsw/1/redhat/7/x86_64/cdsw/1.1.1/
gpgkey =https://archive.cloudera.com/cdsw/1/redhat/7/x86_64/cdsw/RPM-GPG-KEY-cloudera
gpgcheck = 1
__EOF__

sudo mv cloudera-cdsw.repo /etc/yum.repos.d
sudo rpm --import https://archive.cloudera.com/cdsw/1/redhat/7/x86_64/cdsw/RPM-GPG-KEY-cloudera
sudo yum -y install cloudera-data-science-workbench

## Installing NVIDIA Driver
cd /tmp
NVIDIA_DRIVER_VERSION="381.22"
wget http://us.download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_DRIVER_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run
sudo chmod 755 NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run
sudo mkdir /opt/nvidia
sudo mv NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run /opt/nvidia

## Installing nvidia-docker
cd /tmp
wget https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker-1.0.1-1.x86_64.rpm
sudo yum -y install nvidia-docker-1.0.1-1.x86_64.rpm
sudo mv nvidia-docker-1.0.1-1.x86_64.rpm /opt/nvidia
