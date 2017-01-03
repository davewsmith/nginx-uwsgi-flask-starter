#!/bin/bash

echo `pwd` >> /vagrant/whereami

sudo apt-get update
# This is pro-forma, and not necessary while playing around
#sudo apt-get upgrade -y

# Basic quality-of-lift stuff
sudo apt-get install -y vim git


sudo apt-get install -y build-essential python3-dev python3-setuptools python3-pip
# sudo apt-get install -y python3.5-dev  # needed?
sudo apt-get install -y python-virtualenv
sudo apt-get install -y sqlite3

cd /vagrant
virtualenv venv --python=python3
. venv/bin/activate
pip install -r requirements.txt

# sudo apt-get install -y nginx


