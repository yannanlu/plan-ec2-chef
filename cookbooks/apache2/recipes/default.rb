pkg_name = node[cookbook_name]['pkg_name']

case node['platform']
when "debian","ubuntu"
  apt_package pkg_name do
    action :install
  end
when "redhat","centos"
  yum_package pkg_name do
    action :install
  end

  yum_package 'mod_ssl' do
    action :install
  end
end

service cookbook_name do
  service_name pkg_name
  supports :status => true, :restart => true
  action [:enable, :nothing]
end

include_recipe "#{cookbook_name}::monit"
