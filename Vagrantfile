
Vagrant.configure(2) do |config|
    # config.vm.box = "debian/jessie64"  # alas, no guest additions in this box
    config.vm.box = "ubuntu/xenial64"
    config.vm.network "forwarded_port", guest: 5000, host: 5000
    config.vm.network :private_network, ip: "10.10.10.10"

    config.vm.provider "virtualbox" do |vb|
        vb.name = "Flask Starter"
        vb.memory = 1024
        vb.cpus = 1
    end

    config.vm.provision :shell, :path => "provision/provision.sh"
end
