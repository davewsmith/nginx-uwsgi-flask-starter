# Provision a Virtual Machine that's 'close enough' to Raspbian 9
# (Stretch) and set up a simple Flask app under uwsgi that's
# reverse-proxied by nginx

Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu/bionic64"
    config.vm.network "forwarded_port", guest: 80, host: 8000
    config.vm.network "forwarded_port", guest: 5000, host: 5000  # for flask devserver
    config.vm.network :private_network, ip: "10.10.10.10"

    config.vm.provider "virtualbox" do |vb|
        vb.name = "Flask Starter"
        vb.memory = 1024
        vb.cpus = 1
    end

    config.vm.provision "shell", :path => "provision/provision.sh"

    ## Enable this if you want to remove traces of provisioning
    # config.vm.provision "shell", :inline => "rm -rf provision"

    ## This makes git usable from inside the VM
    # config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"
end
