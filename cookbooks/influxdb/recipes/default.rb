influxdb_dir = node[cookbook_name]['dir']

case node['platform']
when "debian","ubuntu"
  apt_package node[cookbook_name]['pkg_name'] do
    action :install
  end
when "redhat","centos"
  cookbook_file File.join("/etc/yum.repos.d", "influxdb.repo") do
    owner "root"
    group "root"
    mode "0644"
    source "influxdb.repo"
  end

  yum_package node[cookbook_name]['pkg_name'] do
    action :install
  end
end

service "influxdb" do
  service_name node[cookbook_name]['pkg_name']
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

include_recipe "#{cookbook_name}::monit"
