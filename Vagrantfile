
Vagrant.configure(2) do |config|
    # config.vm.box = "debian/jessie64"  # alas, no guest additions in this box
    config.vm.box = "ubuntu/xenial64"
    config.vm.network "forwarded_port", guest: 5000, host: 5000
    config.vm.network "forwarded_port", guest: 80, host: 8000
    config.vm.network :private_network, ip: "10.10.10.10"

    config.vm.provider "virtualbox" do |vb|
        vb.name = "Flask Starter"
        vb.memory = 1024
        vb.cpus = 1
    end

    # If all interesting boxes had guest addition, we could just copy from /vagrant/provision
    config.vm.provision "file", source: "provision", destination: "provision"
    config.vm.provision "shell", :path => "provision/provision.sh"

    # Enable this if you want to remove traces of provisioning
    # config.vm.provision "shell", :inline => "rm -rf provision"

    # This makes git usable from inside the VM
    config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"
end
