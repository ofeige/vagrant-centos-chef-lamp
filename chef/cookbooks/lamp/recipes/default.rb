include_recipe "nginx"

# add the remi repo
yum_repository 'remi' do
  description 'Les RPM de remi pour Enterprise Linux'
  mirrorlist 'http://rpms.famillecollet.com/enterprise/$releasever/remi/mirror'
  gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
  action :create
end

# add the remi-php56 repo
yum_repository 'remi-php56' do
  description 'Les RPM de remi pour Enterprise Linux - php56'
  mirrorlist 'http://rpms.famillecollet.com/enterprise/$releasever/php56/mirror'
  gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
  action :create
end

%w(php php-mcrypt php-gd php-mysqlnd php-mbstring php-pdo php-opcache composer).each do |prog|
    package prog do
    options "--enablerepo=remi,remi-php56"
    action :install
  end
end

mysql_service 'foo' do
  port '3306'
  version '5.7'
  initial_root_password "#{node['mysql']['initial_root_password']}"
  action [:create, :start]
end

# enable query cache
mysql_config 'foo' do
  instance 'foo'
  source 'my-mysql-settings.erb'
  notifies :restart, 'mysql_service[foo]'
  action :create
end

node['lamp']['vhosts'].each do |vhost|

	root = "#{node['nginx']['default_root']}/#{vhost}"
	root_without_vhost = "#{node['nginx']['default_root']}"
	template 'wildcard-site' do

   	variables(
  		:root => root,
  		:root_without_vhost => root_without_vhost,
  		:vhost => vhost
  	)

    path "/etc/nginx/sites-available/#{vhost}"
        action :create
        source 'wildcard-site.erb'
        owner 'root'
        group 'root'
        mode '0644'
    end

    link "/etc/nginx/sites-enabled/#{vhost}" do
        to "/etc/nginx/sites-available/#{vhost}"
        notifies :reload, 'service[nginx]', :delayed
    end

end

directory "/var/lib/nginx" do
   owner 'vagrant'
   group 'root'
   mode '0777'
   action :create
end

directory "/var/lib/nginx/tmp" do
   owner 'vagrant'
   group 'root'
   mode '0777'
   action :create
end

php_fpm_pool "www" do
   listen '/var/run/php-fpm-www.sock'
   process_manager "dynamic"
   max_requests 5000
end

file "/etc/php.d/99-timezone.ini" do
    content "[Date]\n date.timezone = 'Europe/Berlin'\n"
end