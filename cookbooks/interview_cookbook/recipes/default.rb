#
# Cookbook Name:: interview_cookbook
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'git::default'
app_path = "#{node['interview']['home_dir']}/#{node['interview']['app_dir']}"
release_path = "#{app_path}/current"

directory node['interview']['home_dir'] do
  owner 'ubuntu'
  group 'ubuntu'
  mode  '0755'
end

deploy "#{node['interview']['home_dir']}/#{node['interview']['app_dir']}" do
  repo 'https://github.com/patrick-armitage/sample_rails_app.git'
  environment 'RAILS_ENV' => 'production'
  revision 'HEAD'
  action :deploy
  migrate false
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
end

template "#{node['nginx']['dir']}/sites-available/default" do
  source 'nginx_sites_available_puma.erb'
  notifies :reload, 'service[nginx]', :delayed
end

nginx_site 'default' do
  action :enable
end

execute 'chown release path' do
  command "chown -R ubuntu:ubuntu #{release_path}"
  action :nothing
end

execute 'bundle install' do
  cwd release_path
  user 'ubuntu'
  environment 'RAILS_ENV' => 'production'
  action :run
end

execute 'rake assets:precompile' do
  cwd release_path
  user 'ubuntu'
  environment 'RAILS_ENV' => 'production'
  action :run
end

execute 'start rails' do
  cwd release_path
  user 'ubuntu'
  environment 'RAILS_ENV' => 'production'
  command "rails server -d -b '#{release_path}/tmp/sockets/puma.sock'"
  action :run
end
