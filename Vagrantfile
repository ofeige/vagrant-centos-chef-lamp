# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = "lamudi/centos-7.0"

    if !Vagrant.has_plugin?('vagrant-cachier')
        puts "The vagrant-cachier plugin is required. Please install it with \"vagrant plugin install vagrant-cachier\""
        exits
    end

    if !Vagrant.has_plugin?('vagrant-hostmanager')
        puts "The vagrant-hostmanager plugin is required. Please install it with \"vagrant plugin install vagrant-hostmanager\""
        exit
    end

  # set cache scope for cachier
    config.cache.scope = :box

    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", 2048]
        vb.customize ["modifyvm", :id, "--cpus", 2]
    end

    config.vm.provider "parallels" do |v|
        v.memory = 2048
        v.cpus = 2
    end    

  # vagrant-hostmanager config (https://github.com/smdahlen/vagrant-hostmanager)
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true

    config.vm.define "project" do |node|
        # dns name in VM and Host
        node.vm.hostname = 'of-vm-box'
        # set a dedicated ip
        node.vm.network :private_network, ip: '192.168.13.37'
        node.hostmanager.aliases = %w(www.project1.local www.project2.local)
	    config.vm.network :forwarded_port, guest: 3306, host: 3306
    end

   # config.omnibus.chef_version = :latest

    config.vm.synced_folder ".", "/vagrant", :owner => "vagrant", :group => "vagrant"

    # If true, then any SSH connections made will enable agent forwarding.
    # Default value: false
    config.ssh.forward_agent = true

    # chef solo part
    config.vm.provision :chef_zero do |chef|
    chef.cookbooks_path = ["chef/cookbooks/"]

        chef.add_recipe "lamp"
        chef.add_recipe "php-fpm"


        chef.json = {
            :lamp  => {
                vhosts: [ "project1.local", "project2.local" ]
            },
            :mysql => {
                port: 3306,
                version: '5.7',
                initial_root_password: 'changeme',
            },
            :nginx => {
                default_site_enabled: false,
                sendfile: "off",
                default_root: "/vagrant",
                listen: "unix:/var/run/php-fpm-www.sock",
                user: "vagrant",
                group: "vagrant",
            },
            :'php-fpm' => {
                user: "vagrant",
                group: "vagrant"
            }
        }

    end
end


