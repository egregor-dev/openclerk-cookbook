#
# Cookbook Name:: openclerk
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"
include_recipe "mysql::client"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"

apache_site "default" do
  enable true
end

cookbook_file "phpinfo.php" do
  path "/var/www/phpinfo.php"
end

mysql_database node['openclerk']['database'] do
  connection(
    :host     => 'localhost',
    :username => 'root',
    :password => node['mysql']['server_root_password']
  )
  action :create
end

mysql_database_user node['openclerk']['db_username'] do
  connection (
    :host     => 'localhost'
    :username => 'root'
    :password => node['mysql']['server_root_password']
  )
  password node['openclerk']['db_password']
  database_name node['openclerk']['database']
  privileges [:select, :update, :insert, :create, :delete]
  action :grant
end

