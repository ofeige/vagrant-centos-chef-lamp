# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# force minimum vagrant version
Vagrant.require_version ">= 1.6.5"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    # box definition
    config.vm.box = "lamudi/centos-7.0"

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

    # check if plugin is installed
    if !Vagrant.has_plugin?('vagrant-hostmanager')
        puts "The vagrant-hostmanager plugin is required. Please install it with \"vagrant plugin install vagrant-hostmanager\""
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

    # vagrant-hostmanager config (https://github.com/smdahlen/vagrant-hostmanager)

    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
    config.vm.define "angi" do |node|
        # dns name in VM and Host
        node.vm.hostname = 'angi.dev'
        # set a dedicated ip
        node.vm.network :private_network, ip: '192.168.13.37'
        node.hostmanager.aliases = %w(kpi-lk-dev.angi.dev messages-lk-dev.angi.dev messages-mm-dev.angi.dev messages-mm-dev.angi.dev messages-mx-dev.angi.dev messages-mx-dev.angi.dev)
    end

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
		chef.add_recipe "xdebug"
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
            vhosts: [ "angi.dev" ]
        },
        :xdebug => {
            'web_server' => {
              service_name: 'nginx'
            },
            config_file: '/etc/php.d/xdebug.ini',
            'directives' => {
              "remote_autostart" => 1,
              "remote_connect_back" => 1,
              "remote_enable" => 1,
              "remote_log" => '/tmp/remote.log',
              "profiler_output_dir" => '/var/tmp',
              "profiler_enable_trigger" => '1',
              "profiler_enable" => '0',
              "remote_connect_back" => '1',
              "remote_port" => '9001',
              "remote_handler" => 'dbgp',
              "remote_autostart" => '0',
              "default_enable" => '1',
              "cli_color" => '2',
              "overload_var_dump" => '1',
              "show_local_vars" => '1'

            }
        }

    }
    end

    config.vm.post_up_message = "Happy Coding @Lamudi ! Thanks to all contributors! \n\nAnd as always: A programmer is a device for turning coffee into code. (ok..maybe tea also..)\n\nRead doc/sudoers file if you do not want to enter root password on every vagrant up!"
end
