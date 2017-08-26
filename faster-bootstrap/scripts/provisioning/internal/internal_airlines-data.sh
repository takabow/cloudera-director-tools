#!/bin/sh

sudo mkdir /opt/data
sudo chmod 644 /opt/data
cd /opt/data

sudo yum -y install wget

# Downloading airlines data
wget https://ibis-resources.s3.amazonaws.com/data/airlines/airlines_parquet.tar.gz
tar xvzf airlines_parquet.tar.gz

wget https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat
