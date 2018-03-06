nginx_dir = node['nginx']['dir']

package node[cookbook_name]['pkg_name'] do
  action :install
end

template File.join(nginx_dir, "nginx.conf") do
  owner "root"
  group "root"
  mode 0644
  source "nginx.conf.erb"
  notifies :restart, "service[nginx]"
end

%w{server.crt server.key}.each do |f|
  cookbook_file File.join(nginx_dir, f) do
    source f
    owner 'root'
    group 'root'
    mode '0600'
    notifies :restart, "service[nginx]"
  end
end

template File.join(nginx_dir, 'conf.d', 'default.conf') do
  source 'default.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :locations => node['nginx']['locations']
  )
  notifies :restart, "service[nginx]"
end

service "nginx" do
  supports :status => true, :restart => true
  action [:enable, :nothing]
end

include_recipe "nginx::monit"
