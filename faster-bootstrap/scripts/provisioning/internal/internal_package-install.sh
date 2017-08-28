#!/bin/sh

cd /tmp

sudo yum -y update

# some tools
sudo yum -y install gcc
sudo yum -y install wget
sudo yum -y install git
sudo yum -y install jq
sudo yum -y install perl
sudo yum -y install dnsmasq


# Secure cluster
sudo yum -y install krb5-server krb5-workstation
sudo yum -y install bind-utils
sudo yum -y install nmap
sudo yum -y install xinetd
sudo systemctl stop xinetd


# Java and Maven
cd /tmp

ln -nfs /usr/java/jdk1.8.0_121-cloudera /usr/java/latest
ln -nfs /usr/java/latest /usr/java/default

wget http://ftp.kddilabs.jp/infosystems/apache/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz
tar xzvf apache-maven-3.5.0-bin.tar.gz
sudo mv apache-maven-3.5.0 /opt

cat <<'EOF'>> maven.sh
export M2_HOME=/opt/apache-maven-3.5.0
export M2=$M2_HOME/bin
export JAVA_HOME=/usr/java/jdk1.8.0_121-cloudera
export PATH=$JAVA_HOME/bin:$M2:$PATH
EOF

sudo mv maven.sh /etc/profile.d/maven.sh


# Python3
sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm
sudo yum install -y python36u python36u-libs python36u-devel python36u-pip
sudo ln -s /usr/bin/python3.6 /usr/bin/python3
sudo ln -s /usr/bin/pip3.6 /usr/bin/pip3
