# Build an Nginx/uWSGI/Python3/Flask VM

This project provides a recipe for building a basic Virtual Machine
with Ubuntu 18.04 (Bionic),
that sets up a simple Flask application under uwgi to be
reverse-proxied by nginx, with nginx serving up the static parts
of the application directly.

This is pretty much the configuration you'll need to deploy onto
a Raspberry Pi under Raspbian Stretch, though there's nothing
Pi-specific here.

You may have found your way here after struggling to get a similar stack
deployed. You've probably seen stackoverflow posts about weird problems
that can happen along the way if you don't get the incantations exactly right.
Study the provisioning script carefully. If you must diverge, test frequently.  

## Requirements

Building the VM requires VirtualBox and Vagrant. On Linux (Ubuntu)

    sudo apt-get install virtualbox

gets you the former. `http://vagrant.io` gets you the latter.

## Building a VM

Pull this down from github, then

    vagrant up

On my Linux laptop, with an SSD over a mediocre network connection,
it takes about 10-15 minutes to build a VM.
Once done, `http://localhost:8000` reaches the minimal flask starter
app running inside the VM.

 `vagrant ssh` gets you a shell in the VM.

Exit that shell and `vagrant suspend` to put the VM to bed.

`vagrant reload` brings it back.

Those are the bare basics. Consult the Vagrant docs for more.

## Making changes

As you extend the Flask app, you can either check your work using `flask`
directly (see below), or you can restart services to see your changes.
For that, you'll want to `vagrant ssh` into the VM
and

    sudo systemctl restart ngingx
    sudo systemctl restart uwsgi

## When something breaks

If you change something and `http://localhost:8000/` fails to reach the app,
it's time to `vagrant ssh` into the VM.

First, check the Flask app.

    cd /vagrant
    export FLASK_DEBUG=1
    expoert FLASK_APP=starter/starter.py
    venv/bin/flask run --host 0.0.0.0

From a browser outside of the VM, visit `http://localhost:5000`.
Flask will spew errors into the browser, into the console, and sometimes both.

If your app works on :5000, the problem probably isn't your app.

To debug configuration configuration changes, try

    cd /vagrant
    uwsgi -H venv --http 0.0.0.0:5000 -M -w starter:app

then visit `http://localhost:5000`.

It's also useful to consult logs. The useful ones are

  * `/var/log/uwsgi/emperor.log`
  * `/var/log/uwsgi/starter.log`
  * `/var/log/nginx/error.log`
  * `/var/log/nginx/access.log`

## Deploying to a Pi

At the moment, it's a matter of pulling this code down onto a Pi,
ignoring `Vagrantfile`,
and manually performing the steps in `provision/provision.sh`.
Simplifying that is on my TODO list.
At the moment I'm taking the lazy approach of deploying to `/vagrant` on the Pi.

## But but but...

This is unwarrantied, use-at-your-own-risk-ware.
Pull requests that fix egregious problems are welcome;
feature PRs may be ignored.
And yeah, `gunicorn` is a viable alternative to `uwsgi`, but don't use it for reasons.

