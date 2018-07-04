#!/bin/bash

sudo apt-get update
# This is pro-forma, and not necessary if only playing around.
# sudo apt-get upgrade -y

# Ensure basic quality-of-life
sudo apt-get install -y vim git

# Python parts
sudo apt-get install -y build-essential python3-dev python3-setuptools python3-pip
sudo apt-get install -y python-virtualenv

# Set up the virtual environment and install dependencies
cd /vagrant
virtualenv venv --python=python3
venv/bin/pip install -r requirements.txt

# Set up nginx and uswgi
sudo apt-get install -y nginx
sudo apt-get install -y python-pip
sudo pip3 install uwsgi

sudo touch /tmp/uwsgi.socket
sudo chmod 666 /tmp/uwsgi.socket
sudo chown www-data:www-data /tmp/uwsgi.socket
sudo mkdir /var/log/uwsgi
sudo chown www-data:www-data /var/log/uwsgi

sudo rm /etc/nginx/sites-enabled/default
sudo cp provision/starter.nginx /etc/nginx/sites-available/starter
sudo ln -s /etc/nginx/sites-available/starter /etc/nginx/sites-enabled/

mkdir -p /etc/uwsgi/apps-available /etc/uwsgi/apps-enabled
sudo cp provision/starter.ini /etc/uwsgi/apps-available/
sudo ln -s /etc/uwsgi/apps-available/starter.ini /etc/uwsgi/apps-enabled/

# Let systemd know about uwsgi
sudo cp provision/uwsgi.service /etc/systemd/system/
sudo systemctl daemon-reload

# Restart uwsgi and nginx
sudo systemctl start uwsgi
sudo systemctl restart nginx

# systemctl status uwsgi.service
