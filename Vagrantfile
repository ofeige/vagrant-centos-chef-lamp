# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Detect host OS for different folder share configuration
module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def OS.mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def OS.unix?
        !OS.windows?
    end

    def OS.linux?
        OS.unix? and not OS.mac?
    end
end

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
config.vm.box = "bento/centos-7.3"

  config.vm.provider "parallels"
  config.vm.provider "virtualbox"
  
  if !Vagrant.has_plugin?('vagrant-cachier')
    puts "The vagrant-cachier plugin is required. Please install it with \"vagrant plugin install vagrant-cachier\""
    exits
  end

  if !Vagrant.has_plugin?('vagrant-hostmanager')
    puts "The vagrant-hostmanager plugin is required. Please install it with \"vagrant plugin install vagrant-hostmanager\""
    exit
  end
  
  if OS.windows?      
    if !Vagrant.has_plugin?('vagrant-winnfsd')         
      puts "The vagrant-winnfsd plugin is required. Please install it with \"vagrant plugin install vagrant-winnfsd\""   
      exit
    end
  end
    
  if Vagrant.has_plugin?('vagrant-vbguest')
      config.vbguest.auto_update = true
  end
  
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
    node.vm.hostname = 'small-projects'
    node.vm.network :private_network, ip: '192.168.13.37'
    node.hostmanager.aliases = %w(project1 project2)
    config.vm.network :forwarded_port, guest: 3306, host: 3306
  end

  # config.omnibus.chef_version = :latest

  # configure shared folders
  if OS.windows?
    config.vm.synced_folder ".", "/vagrant", type: "nfs"
  else
    config.vm.synced_folder ".", "/vagrant", :owner => "vagrant", :group => "vagrant"
  end

  config.ssh.forward_agent = true

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["chef/cookbooks/"]

    chef.add_recipe "yum-mysql-community::mysql57"
    chef.add_recipe "lamp"

    chef.json = {
      :lamp  => {
        vhosts: [ "project1", "project2" ]
      },
      :mysql => {
        port: 3306,
        version: '5.7',
        initial_root_password: 'changeme',
      },
      :nginx => {
        default_site_enabled: false,
        port: 80,
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
