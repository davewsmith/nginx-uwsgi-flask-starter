#!/bin/bash

echo `pwd` >> /vagrant/whereami

sudo apt-get update
# This is pro-forma, and not necessary while playing
#sudo apt-get -y upgrade

# Basic quality-of-lift stuff
sudo apt-get -y install vim git


sudo apt-get -y install build-essential python3-dev python3.4-dev python3-setuptools python3-pip
sudo apt-get -y install python-virtualenv
sudo apt-get -y install sqlite3

# sudo apt-get -y install nginx

cd /vagrant
virtualenv venv --python=python3
. venv/bin/activate
pip install -r requirements.txt

