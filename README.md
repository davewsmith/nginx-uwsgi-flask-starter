# Build an Nginx/uWSGI/Python3/Flask VM

This project builds a Virtual Machine for Flask development, using nginx, uwsgi, and Python3, with nginx serving a simple starter app's static files. It allows local development for web apps that will eventually be deployed to a Raspberry Pi, but there's nothing Pi-specific here.

I put this together to record the fiddly bits of getting started with this stack. The VM is based on Ubuntu 16.04 instead of something closer to Jessie, mostly because I couldn't find a Debian box that had Vagrant host dir support installed, and 16.04 (like Jessie) uses `systemd`.

You may have found your way here after struggling to get a similar stack deployed. You've probably seen stackoverflow posts about weird problems that can happen along the way if you don't get the incantations exactly right. Study the provisioning script carefully. If you must diverge, test frequently.

## Requirements

This was developed on a laptop running Ubuntu 14.04.

Building the VM requires VirtualBox and Vagrant

    sudo apt-get install virtualbox

gets you the former. `http://vagrant.io` gets you the latter.

## Building a VM

Pull this down from github, then

    vagrant up

On my Linux laptop, with an SSD over a mediocre network connection, it takes about 10-15 minutes to build a VM. Once done, `http://localhost:8000` reaches the minimal flask starter app running inside the VM. `vagrant ssh` gets you a shell in the VM. Exit that shell and `vagrant suspend` to put the VM to bed. `vagrant reload` brings it back. Those are the bare basics. Consult the Vagrant docs for more.

## Making changes

As you extend the Flask app, you can either check your work using the `flask` tool (see below), or you can restart services to see your changes. For that, you'll want

    sudo systemctl restart ngingx
    sudo systemctl restart uwsgi

at your fingertips.

## When something breaks

If you change something and `http://localhost:8000/` fails to reach the app, it's time to `vagrant ssh` into the VM.

First, check the Flask app. For this you'll need to activate the virtual environment.

    cd /vagrant
    . venv/bin/activate
    FLASK_APP=starter/starter.py flask run --host 0.0.0.0

From a browser outside of the VM, visit `http://localhost:5000`

If that works, the problem probably isn't your app.

To debug configuration, try

    cd /vagrant
    uwsgi -H venv --http 0.0.0.0:5000 -M -w starter:app

then visit `http://localhost:5000`. It's often useful to consult `/var/log/uwsgi/emperor.log`

## Deploying to a Pi

At the moment, it's a matter of pulling this code down onto a Pi, ignoring `Vagrantfile`, and manually performing the steps in `provision/provision.sh`. Simplifying that is on my list. At the moment I'm taking the lazy approach of deploying to `/vagrant` on the Pi.

## But but but...

This is unwarrantied, use-at-your-own-risk-ware. Pull requests that fix egregious problems are welcome; feature PRs may be ignored. And yeah, I could use `gunicorn`, but don't for reasons. It's an entirely viable option.

