influxdb_dir = node[cookbook_name]['dir']

case node['platform']
when "debian","ubuntu"
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

service "influxdb" do
  service_name node[cookbook_name]['pkg_name']
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

include_recipe "#{cookbook_name}::monit"
