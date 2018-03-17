nginx_dir = node['nginx']['dir']

package node[cookbook_name]['pkg_name'] do
  action :install
end

template File.join(nginx_dir, "nginx.conf") do
  owner "root"
  group "root"
  mode 0644
  source "nginx.conf.erb"
  variables(
    :cfgdir => nginx_dir,
    :user => node['nginx']['user'],
    :logdir => node['nginx']['logdir'],
    :pidfile => node['nginx']['pidfile']
  )
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
    :cfgdir => nginx_dir,
    :logdir => node['nginx']['logdir'],
    :locations => node['nginx']['locations']
  )
  notifies :restart, "service[nginx]"
end

template File.join(nginx_dir, 'conf.d', 'server.conf') do
  source 'server.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :port => node['nginx']['extra_server']['port'],
    :server_name => node['nginx']['extra_server']['server_name'],
    :docroot => node['nginx']['extra_server']['docroot'],
    :logdir => node['nginx']['logdir'],
    :log_locations => node['nginx']['log_locations']
  )
  not_if { node['nginx']['extra_server'].empty? }
  notifies :restart, "service[nginx]"
end

service "nginx" do
  supports :status => true, :restart => true
  action [:enable, :nothing]
end

include_recipe "nginx::monit"
