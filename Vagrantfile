# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# cluster configure
cluster = {
  "master"   => { :ip => "10.245.5.2", :cpus => 1, :memory => 1024 },
  "slave-1"  => { :ip => "10.245.5.5", :cpus => 1, :memory => 1024 },
  "slave-2"  => { :ip => "10.245.5.6", :cpus => 1, :memory => 1024 },
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
###############################################################################
# Global plugin settings                                                      #
###############################################################################
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
    config.cache.auto_detect = true
    config.cache.synced_folder_opts = {
      type: :nfs,
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
  end
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = false
    config.hostmanager.manage_host = false
    config.hostmanager.ignore_private_ip = false
  end
  # ssh
  config.ssh.insert_key = false

###############################################################################
# Base box                                                                    #
###############################################################################
  config.vm.box         = "ubuntu/trusty64"

  cluster.each_with_index do |(hostname, info), index|
    config.vm.define hostname do |cfg|
      cfg.vm.hostname = hostname

      # virtualbox
      cfg.vm.provider :virtualbox do |vb|
        vb.name   = "kubernetes-#{hostname}"
        vb.cpus   = info[:cpus]
        vb.memory = info[:memory]
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end

      # network
      cfg.vm.network :private_network, ip: "#{info[:ip]}", nictype: "virtio"
      if index == 0 
        cfg.vm.network "forwarded_port", guest: 8080, host: 8080
      end

      # provision
      if index == cluster.size - 1
        cfg.vm.provision "ansible" do |ansible|
          ansible.sudo           = true
          ansible.limit          = "all"
          ansible.playbook       = "provision/development.yml"
          ansible.inventory_path = "provision/development"
        end 
      end
    end
  end
end
