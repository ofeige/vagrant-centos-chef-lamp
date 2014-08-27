#include_recipe "apt" if platform?("ubuntu", "debian")
#include_recipe "yum" if platform_family?("rhel")
#include_recipe "mysql::client"
#include_recipe "mysql::server"
#include_recipe "database::mysql"
#include_recipe "apache2"
#include_recipe "apache2::mod_php5"
#include_recipe "apache2::mod_rewrite"
#include_recipe "apache2::mod_deflate"
#include_recipe "apache2::mod_headers"
include_recipe "nginx"

include_recipe "iptables::disabled"


# add the EPEL repo
yum_repository 'epel' do
  description 'Extra Packages for Enterprise Linux'
  mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  action :create
end

# add the remi repo
yum_repository 'remi' do
  description 'Les RPM de remi pour Enterprise Linux'
  mirrorlist 'http://rpms.famillecollet.com/enterprise/$releasever/remi/mirror'
  gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
  action :create
end

# add the remi-php55 repo
yum_repository 'remi-php55' do
  description 'Les RPM de remi pour Enterprise Linux - php55'
  mirrorlist 'http://rpms.famillecollet.com/enterprise/$releasever/php55/mirror'
  gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
  action :create
end

%w( vim-enhanced mc less screen lynx curl telnet w3m ).each do |prog|
	package prog do
		action :install
	end
end

%w( php php-fpm php-mcrypt php-gd php-xml php-ldap php-mysql php-mysqlnd php-mbstring).each do |prog|
  package prog do
    options "--enablerepo=remi,remi-php55"
    action :install
  end
end

#mysql_service 'default' do
#      allow_remote_root true
#      remove_anonymous_users true
#      remove_test_database true
#      server_root_password 'test'
#      action :create
#end

#mysql_connection_info = {
#  :host     => 'localhost',
#  :username => 'root',
#  :password => 'test'
#}

#mysql_database 'symphony' do
#  connection mysql_connection_info
#  action :create
#end

#or import from a dump file
#mysql_database "myapp" do
#  connection mysql_connection_info
#  sql { ::File.open('/vagrant/data/mysql.schema.sql').read }
#  action :query
#end

#database_user 'myapp_user' do
#  connection mysql_connection_info
#  password   'super_secret'
#  provider   Chef::Provider::Database::MysqlUser
#  action     :create
#end

#mysql_database_user 'myapp_user' do
#  connection    mysql_connection_info
#  password      'super_secret'
#  database_name 'myapp'
#  host          '%'
#  privileges    [:all]
#  action        :grant
#end

#web_app "opf_testapp" do
#  server_name "localhost"
#  server_aliases ["localhost"]
#  docroot "/vagrant/web"
#end

file "/etc/php.d/99-display_errors.ini" do
  owner "root"
  group "root"
  mode "0644"
  action :create
  content "display_errors = On"
#  notifies :restart, "service[apache2]", :delayed
end

file "/etc/php.d/99-default_timezone.ini" do
  owner "root"
  group "root"
  mode "0644"
  action :create
  content "date.timezone = 'Europe/Berlin'"
#  notifies :restart, "service[apache2]", :delayed
end

file "/etc/profile.d/vialias.sh" do
	owner "root"
	group "root"
	mode "0644"
	action :create
	content "alias vi=vim"
end

file "root/.vimrc" do
	owner "root"
	group "root"
	mode "0644"
	content "syntax on
set noai
set ts=4
colorscheme desert"
	action :create
end

directory "/var/www/nginx-default/" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

file "/var/www/nginx-default/index.php" do
	owner "root"
	group "root"
	mode "0644"
	content "<?php phpinfo(); ?>"
	action :create
end

execute "auto start php-fpm" do
    command "chkconfig php-fpm on"
end

service 'php-fpm' do
  supports :status => true, :restart => true, :reload => true
  action   :start
end

template 'default-site' do
  path "/etc/nginx/sites-available/default"
  action :create
  source 'default-site.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[nginx]', :delayed
end

