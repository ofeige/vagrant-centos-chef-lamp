# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "chef/centos-7.0"

    # check if plugin is installed
    if !Vagrant.has_plugin?('vagrant-omnibus')
        puts "The vagrant-omnibus plugin is required. Please install it with \"vagrant plugin install vagrant-omnibus\""
        exit
    end

    # check if plugin is installed
    if !Vagrant.has_plugin?('vagrant-cachier')
        puts "The vagrant-cachier plugin is required. Please install it with \"vagrant plugin install vagrant-cachier\""
        exit
    end

    # check if plugin is installed
    if !Vagrant.has_plugin?('nugrant')
        puts "The nugrant plugin is required. Please install it with \"vagrant plugin install nugrant\""
        exit
    end

    # set cache scope for cachier
    config.cache.scope = :box

    # set default value for nugrant

    config.user.defaults = {
        "virtualbox" => {
            "memory" => "2048",
            "cpus" => "2",
        }
    }
    # modify virtualbox to set cpu/mem and some useful performance options
    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", config.user.virtualbox.memory]
        vb.customize ["modifyvm", :id, "--cpus", config.user.virtualbox.cpus]
        vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
        vb.customize ["modifyvm", :id, "--nestedpaging", "on"]
        vb.customize ["modifyvm", :id, "--largepages", "on"]
        vb.customize ["modifyvm", :id, "--vtxvpid", "on"]
    end

    # port forwarding
    config.vm.network :forwarded_port, guest: 80, host: 8081
    config.vm.network :forwarded_port, guest: 3306, host: 3306

    config.omnibus.chef_version = :latest

    config.vm.synced_folder ".", "/vagrant", :owner => "vagrant", :group => "vagrant"

    # If true, then any SSH connections made will enable agent forwarding.
    # Default value: false
    config.ssh.forward_agent = true

    # chef solo part
    config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["chef/cookbooks/"]
    # recipes
    chef.add_recipe "mysql::server"
    chef.add_recipe "lamp"
    chef.add_recipe "php-fpm"
    chef.add_recipe "angi"
    chef.json = {
        :mysql => {
            server_root_password: "test",
            version: '5.6',
            port: '3306',
            allow_remote_root: true,
            remove_anonymous_users: true,
            remove_test_database: true
        },
        :nginx => {
            sendfile: "off",
            default_root: "/vagrant",
            listen: "127.0.0.1:9000",
            user: "vagrant",
            group: "vagrant",
        },

        :'php-fpm' => {
            package_name: "php-fpm",
            user: "vagrant",
            group: "vagrant",
						pools: false
        },
		
        :'angi' => {
            vhosts: [ "dev.angi.dev" ]
        }
    }
    end
end
