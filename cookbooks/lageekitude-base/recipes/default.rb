# Cookbook Name:: lageekitude_base
# Recipe:: default
#
# Copyright 2013, Example Com
#
#

# execute 'DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade'

include_recipe "python"

execute "set locale" do
  command <<-EOC
    export LANGUAGE="en_US.UTF-8"
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    locale-gen en_US.UTF-8
    dpkg-reconfigure locales
    update-locale LANGUAGE=en_US.UTF-8 LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
  EOC
  only_if { `locale | grep -c UTF-8`.to_i == 0 }
end

gem_package "ruby-shadow" do
  action :install
end
execute "apt-get upgrade" do
  command "apt-get upgrade"
end
execute "reboot" do
  command "reboot -f"
  only_if { File.exists?("/var/run/reboot-required") }
end

[
  "build-essential", "nodejs", "python-dev", "tmux",
  "git", "vim", "unzip", "libpq-dev", "nginx", "nginx-extras",
  "libfreetype6", "libfreetype6-dev", "php5-cgi", "php5-cli",
  "php5-mysql", "php5-gd", "php5-curl", "php5-intl", "php5-mcrypt",
  "php5-fpm", "php-pear"
].each do |p|
  package p do
    retries 5
    action :upgrade
  end
end

[
  "ipython", "boto", "nose", "expecter", "dingus", "requests"
].each do |p|
  python_pip p do
    retries 5
    action :upgrade
  end
end

file "/etc/nginx/sites-enabled/default" do
  action :delete
end

cookbook_file "/php-fpm.tgz" do
  source "php-fpm.tgz"
  not_if { ::File.exists?("/etc/php5/fpm/.recipe.flag") }
end
execute "configure php-fpm" do
  command <<-EOC
  tar xzvf /php-fpm.tgz;
  rm /php-fpm.tgz;
  touch /etc/php5/fpm/.recipe.flag
  EOC
  not_if { ::File.exists?("/etc/php5/fpm/.recipe.flag") }
end

cookbook_file "/etc/nginx/nginx.conf" do
  source "nginx.conf"
  action :create
end

if node['user']['name']
  user node['user']['name'] do
    action :modify
    home "/var/www/"
    password `openssl passwd -1 "#{node['user']['password']}"`.strip
  end
end

directory "/var/www" do
  owner "www-data"
  group "www-data"
  recursive true
end

