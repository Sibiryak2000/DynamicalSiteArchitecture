# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.hostname = 'salt'
  config.vm.synced_folder "salt/roots/", "/srv/salt/"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.name = "project-salt"
    vb.cpus = 4
  end
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  
  # SHELL
  config.vm.provision :salt do |salt|
  
    salt.install_master = true
    salt.seed_master = {
      salt: "salt/key/minion.pub"
    }
    salt.minion_config = "salt/minion"
    salt.master_key = "salt/key/master.pem"
    salt.master_pub = "salt/key/master.pub"
    salt.minion_key = "salt/key/minion.key"
    salt.minion_pub = "salt/key/minion.pub"
  end
  config.vm.provision "shell", inline: <<-SHELL
    service salt-minion start && sleep 10
  SHELL
  config.vm.provision :salt do |salt|
    salt.verbose = true
    salt.log_level = "warning"
    salt.colorize = true
    salt.run_highstate = true
  end
end
