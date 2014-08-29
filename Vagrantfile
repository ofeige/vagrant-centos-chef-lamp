# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "chef/centos-7.0"

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.network :forwarded_port, guest: 80, host: 8081
  config.vm.network :forwarded_port, guest: 3306, host: 3306

  config.omnibus.chef_version = :latest

  config.vm.synced_folder ".", "/vagrant", :owner => "vagrant", :group => "vagrant"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["chef/cookbooks/"]
    chef.add_recipe "mysql::server"
    chef.add_recipe "lamp"
		chef.add_recipe "php-fpm"
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
					package_name: "php56-php-fpm",
					user: "vagrant",
					group: "vagrant",

				}
    }
  end
end
