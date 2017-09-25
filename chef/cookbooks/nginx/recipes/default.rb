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

service "nginx" do
  supports :status => true, :restart => true
  action [:enable, :nothing]
end

include_recipe "nginx::monit"
