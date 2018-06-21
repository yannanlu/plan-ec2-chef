pkg_name = node[cookbook_name]['pkg_name']
apache_dir = node['apache']['dir']

case node['platform']
when "debian","ubuntu"
  apt_package pkg_name do
    action :install
  end

  cookbook_file File.join(apache_dir, 'apache2.conf') do
    source 'apache2.conf'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, "service[apache]"
  end

  template File.join(apache_dir, 'sites-available', '000-default.conf') do
    source 'default.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :locations => node['apache']['locations'],
      :conf_dir => apache_dir,
      :mods_dir => node['apache']['modsdir']
    )
    notifies :restart, "service[apache]"
  end
when "redhat","centos"
  yum_package pkg_name do
    action :install
  end

  yum_package 'mod_ssl' do
    action :install
  end

  cookbook_file File.join(apache_dir, 'conf', 'httpd.conf') do
    source 'httpd.conf'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, "service[apache]"
  end

  template File.join(apache_dir, 'conf.d', 'ssl.conf') do
    source 'default.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :locations => node['apache']['locations'],
      :conf_dir => apache_dir,
      :mods_dir => node['apache']['modsdir']
    )
    notifies :restart, "service[apache]"
  end
end

%w{server.crt server.key}.each do |f|
  cookbook_file File.join(apache_dir, f) do
    source f
    owner 'root'
    group 'root'
    mode '0600'
    notifies :restart, "service[apache]"
  end
end

service cookbook_name do
  service_name pkg_name
  supports :status => true, :restart => true
  action [:enable, :nothing]
end

include_recipe "#{cookbook_name}::monit"
