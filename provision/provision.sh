#!/bin/bash
#
# Set up to run a simple Flask application under uwsgi,
# reverse-proxied by nginx

sudo apt-get update
# This is pro-forma, and not necessary if only playing around.
# sudo apt-get upgrade -y

# Ensure basic quality-of-life
# sudo apt-get install -y vim git

# Python parts
sudo apt-get install -y build-essential python3-dev python3-setuptools python3-pip python-virtualenv

# Set up the virtual environment and install dependencies
cd /vagrant
virtualenv venv --python=python3
venv/bin/pip install -r requirements.txt

# Set up uwsgi
sudo pip3 install uwsgi
sudo cp provision/uwsgi.service /etc/systemd/system/
sudo mkdir -p /etc/uwsgi/apps-available /etc/uwsgi/apps-enabled   ### needed?
sudo cp provision/starter.ini /etc/uwsgi/apps-available/
sudo ln -s /etc/uwsgi/apps-available/starter.ini /etc/uwsgi/apps-enabled/starter.ini
sudo mkdir /var/log/uwsgi
sudo chown vagrant:vagrant /var/log/uwsgi

# Set up nginx
sudo apt-get install -y nginx
sudo cp provision/starter.nginx /etc/nginx/sites-available/starter
sudo rm /etc/nginx/sites-enabled/default  # removes a symlink
sudo ln -s /etc/nginx/sites-available/starter /etc/nginx/sites-enabled/

# Let systemd know about uwsgi
sudo systemctl daemon-reload

# Restart uwsgi and nginx
sudo systemctl start uwsgi
sudo systemctl restart nginx

# systemctl status uwsgi.service
