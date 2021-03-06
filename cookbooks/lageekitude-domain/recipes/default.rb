# Cookbook Name:: lageekitude_domain
# Recipe:: default
#
# Copyright 2013, Example Com
#
#

# execute 'DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade'

username = node['user']['name']

service "nginx" do
  action :stop
end

template "/etc/nginx/sites-available/#{node['domain']['name']}.conf" do
  source "nginx.#{node['domain']['template']}.conf"
  variables ({
    :domain => node['domain']
  })
end
link "/etc/nginx/sites-enabled/#{node['domain']['name']}.conf" do
  to "/etc/nginx/sites-available/#{node['domain']['name']}.conf"
end
[ "/var/www/#{node['domain']['name']}",
  "/var/www/#{node['domain']['name']}/htdocs"
].each do |d|
  directory d do
    owner username
    group username
    recursive true
  end
end

service "nginx" do
  action :start
end

mysql_conn = {
  :host => "localhost",
  :username => "root",
  :password => node['mysql']['server_root_password']
}
mysql_database node['domain']['mysql']['dbname'] do
  connection mysql_conn
  action :create
end
mysql_database_user node['domain']['mysql']['dbuser'] do
  connection mysql_conn
  password node['domain']['mysql']['dbpassword']
  host 'localhost'
  database_name node['domain']['mysql']['dbname']
  action :grant
end
