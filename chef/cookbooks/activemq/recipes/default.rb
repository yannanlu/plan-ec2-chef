include_recipe "java::default"

tmp = Chef::Config[:file_cache_path]
artifact = "#{node['activemq']['pkg_name']}-#{node['activemq']['version']}-bin.tar.gz"
url = "#{node['activemq']['repo_url']}/#{node['activemq']['version']}/#{artifact}"
amq_dir = File.join('/opt', "#{node['activemq']['pkg_name']}-#{node['activemq']['version']}")

case node['platform']
when "debian","ubuntu"
  systemd_dir = '/lib/systemd/system'
when "redhat","centos"
  systemd_dir = '/usr/lib/systemd/system'
else
  systemd_dir = '/usr/lib/systemd/system'
end

group node['activemq']['group'] do
  action :create
end

user node['activemq']['user'] do
  action :create
  group node['activemq']['group']
  shell '/sbin/nologin'
  manage_home false
end

directory amq_dir do
  user node['activemq']['user'] 
  group node['activemq']['group']
  mode  '0755'
  action :create
end

remote_file File.join(tmp, artifact) do
  source url
  mode "0644"
  notifies :run, "execute[amq_tarball]", :immediately
end

execute "amq_tarball" do
  command "tar zxf #{tmp}/#{artifact}"
  user node['activemq']['user'] 
  group node['activemq']['group']
  cwd '/opt'
  action :nothing
  notifies :restart, "service[activemq]"
end

link '/opt/activemq' do
  to "/opt/#{node['activemq']['pkg_name']}-#{node['activemq']['version']}"
end

%w{activemq.xml jetty.xml users.properties groups.properties credentials.properties}.each do |item|
  template File.join('/opt/activemq/conf', item) do
    owner node['activemq']['user']
    group node['activemq']['group']
    source "#{item}.erb"
    mode '0644'
    notifies :restart, "service[activemq]"
  end
end

cookbook_file File.join(systemd_dir, 'activemq.service') do
  source 'activemq.service'
  owner 'root'
  group 'root'
  mode '0644'
end

service "activemq" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

include_recipe "activemq::monit"
