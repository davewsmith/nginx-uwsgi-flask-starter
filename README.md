# Build a Pi-shaped VM for an Nginx/uWSGI/Python3/Flask stack

This builds a minimal VM for developing a Flask app that might later be deployed to a Raspberry Pi. The VM uses Ubuntu 16.04 instead of something closer to Raspbian Jessie for convenience. (I couldn't find a Jessie image that had the Vagrant host bits installed.) There's nothing Pi-specific here. Mostly, this documents the fiddly bits of getting uwsgi installed and working, and provides a starting point for 'real' projects.

If you found your way here after struggling with blog posts that walk you through getting a similar stack deployed, you'll probably also have seen many stackoverflow posts asking about weird problems that can happen along the way. Study the provising script carefully. If you must diverge, test frequently.

# Requirements

This was developed on a laptop running Ubuntu 14.04.

Building a VM requires virtualbox and Vagrant

    sudo apt-get install virtualbox

gets you the former. `http://vagrant.io` gets you the latter.

# Building a VM

Pull this down from github, then `vagrant up`. On my Linux laptop with an SSD over a mediocre network connection, it takes about 10-15 minutes to build a VM. Once done, `http://localhost:8000` reaches the minimal flask app running inside the VM.

## Making changes

As you extend the flask app, you have choices. You can either testing using the `flask` tool (see below), or you can restart services to see yourchanges. For that, you'll want

    sudo systemctl restart ngingx
    sudo systemctl restart uwsgi

at your fingertips.

## Testing

If `http://localhost:8000/` fails to reach the app, it's time to `vagrant ssh` into the VM.

First, verify that the Flask app isn't broken. For this you'll need to activate the virtual environment.

    cd /vagrant
    . venv/bin/activate
    FLASK_APP=starter/starter.py flask run --host 0.0.0.0

From a browser outside of the VM, try `http://localhost:5000`

If that works, the problem probably isn't your app, try

    cd /vagrant
    uwsgi -H venv --http 0.0.0.0:500 -M -w app:app

From a browser outside of the VM, try `http://localhost:5000`. Here, it's often useful to consult `/var/log/uwsgi/emperor.log`

## Deploying to a Pi

At the moment, it's a matter of pulling this code down onto a Pi, ignoring `Vagrantfile`, and manually performing the steps in `provision/provision.sh`. Simplifying that is on my list.

## But, but, but...

This is unwarrantied, use-at-your-own-risk-ware. Pull requests that fix egregious problems are welcome; feature PRs may be ignored. I'm not an expert on uWSGI, and suggest taking your questions to #irc or stackoverflow.

