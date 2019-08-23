# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end
  config.vm.network "forwarded_port", guest: 80, host: 3000

  config.vm.provision :shell, path: 'vagrant/bootstrap.sh'
  config.vm.provision :shell, path: 'vagrant/create_default_config.sh'
end
