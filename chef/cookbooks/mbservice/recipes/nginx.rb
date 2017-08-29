include_recipe "#{cookbook_name}"
include_recipe "nginx"

nginx_dir = node['nginx']['dir']

%w{server.crt server.key}.each do |f|
  cookbook_file File.join(nginx_dir, f) do
    source f
    owner 'root'
    group 'root'
    mode '0600'
    notifies :restart, "service[nginx]"
  end
end

cookbook_file File.join(nginx_dir, 'conf.d', 'default.conf') do
  source 'default.conf'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, "service[nginx]"
end
