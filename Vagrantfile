# -*- mode: ruby -*-
# vi: set ft=ruby :

$puppet_script = <<SCRIPT
#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get -q -y --force-yes install puppet
SCRIPT



# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.synced_folder "srv/roots/", "/srv/"

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
  end

  
  
  config.vm.define "node0", primary: true do |node0|
    node0.vm.hostname = "node0"
    node0.vm.network :forwarded_port, guest: 60010, host:60010
    node0.vm.network :forwarded_port, guest: 50070, host:50070
    node0.vm.network :forwarded_port, guest: 4040, host:4040
    node0.vm.network :forwarded_port, guest: 8088, host:8088
    node0.vm.network :forwarded_port, guest: 8080, host:8089
    node0.vm.network :forwarded_port, guest: 5005, host:5005
    node0.vm.network :private_network, ip: "10.1.1.10",
      virtualbox__intnet: "hadoop"
  end

  config.vm.define "node1" do |node1|
    node1.vm.hostname = "node1"
    node1.vm.network :forwarded_port, guest: 50070, host:50071
    node1.vm.network :forwarded_port, guest: 4040, host:4041
    node1.vm.network :private_network, ip: "10.1.1.11",
      virtualbox__intnet: "hadoop"
  end

  config.vm.define "node2" do |node2|
    node2.vm.hostname = "node2"
    node2.vm.network :forwarded_port, guest: 50070, host:50072
    node2.vm.network :forwarded_port, guest: 4040, host:4042
    node2.vm.network :private_network, ip: "10.1.1.12",
      virtualbox__intnet: "hadoop"
  end

  config.vm.define "node3" do |node3|
    node3.vm.hostname = "node3"
    node3.vm.network :forwarded_port, guest: 50070, host:50073
    node3.vm.network :forwarded_port, guest: 4040, host:4043
    node3.vm.network :private_network, ip: "10.1.1.13",
      virtualbox__intnet: "hadoop"
  end

  config.vm.define "node4" do |node4|
    node4.vm.hostname = "node4"
    node4.vm.network :forwarded_port, guest: 50070, host:50074
    node4.vm.network :forwarded_port, guest: 4040, host:4044
    node4.vm.network :private_network, ip: "10.1.1.14",
      virtualbox__intnet: "hadoop"
  end

   config.vm.provision :shell, :inline => $puppet_script

	
   config.vm.provision :puppet do |puppet|
     puppet.manifests_path = "manifests"
     puppet.module_path = "modules"
     puppet.manifest_file  = "default.pp"
   end

end
