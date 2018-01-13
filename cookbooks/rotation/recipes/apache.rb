include_recipe "apache2"

apache2_dir = node['apache2']['dir']

%w{server.crt server.key}.each do |f|
  cookbook_file File.join(apache2_dir, f) do
    source f
    owner 'root'
    group 'root'
    mode '0600'
    notifies :restart, "service[apache2]"
  end
end

case node['platform']
when "debian","ubuntu"
  cookbook_file File.join(apache2_dir, 'apache2.conf') do
    source 'apache2.conf'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, "service[apache2]"
  end

  template File.join(apache2_dir, 'sites-available', '000-default.conf') do
    source 'default.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :conf_dir => apache2_dir,
      :mods_dir => node['apache2']['modsdir']
    )
    notifies :restart, "service[apache2]"
  end
when "redhat","centos"
  cookbook_file File.join(apache2_dir, 'conf', 'httpd.conf') do
    source 'httpd.conf'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, "service[apache2]"
  end

  template File.join(apache2_dir, 'conf.d', 'ssl.conf') do
    source 'default.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :conf_dir => apache2_dir,
      :mods_dir => node['apache2']['modsdir']
    )
    notifies :restart, "service[apache2]"
  end
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :hostname => node['hostname']
  )
end
