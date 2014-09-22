# 

node['angi']['vhosts'].each do |vhost|

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
