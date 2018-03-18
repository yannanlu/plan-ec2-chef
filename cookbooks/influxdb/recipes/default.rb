influxdb_dir = node[cookbook_name]['dir']

case node['platform']
when "debian","ubuntu"
  apt_repository 'repo_influxdb' do
    uri node[cookbook_name]['repo_uri']
    key node[cookbook_name]['gpg_key']
    distribution node[cookbook_name]['distribution']
    components node[cookbook_name]['components']
    action :add
    notifies :update, "apt_update[influxdb]", :immediately
  end

  apt_update "influxdb" do
    action :nothing
  end

  apt_package node[cookbook_name]['pkg_name'] do
    action :install
  end
when "redhat","centos"
  yum_repository cookbook_name do
    description "InfluxDB Repository"
    baseurl node[cookbook_name]['repo_uri']
    gpgkey node[cookbook_name]['gpg_key']
    action :create
  end

  yum_package node[cookbook_name]['pkg_name'] do
    flush_cache [ :before ]
    action :install
  end
end

execute "pip_influxdb" do
  command "pip install influxdb"
  not_if "pip list | grep influxdb"
end

service cookbook_name do
  service_name node[cookbook_name]['pkg_name']
  supports :status => true, :restart => true
  action [ :enable, :start ]
  notifies :run, "execute[influxdb_pause]", :immediately
end

execute "influxdb_pause" do
  command "sleep 5"
  action :nothing
end

db_name = node[cookbook_name]['db_name']
if db_name != nil
  execute "influxdb_create_db" do
    command "/usr/bin/influx -precision rfc3339 -execute 'create database #{db_name}'"
    not_if "/usr/bin/influx -precision rfc3339 -execute 'show databases' | grep #{db_name}"
  end
end

include_recipe "#{cookbook_name}::monit"
