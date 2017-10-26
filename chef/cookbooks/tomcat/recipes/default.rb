include_recipe "java::default"

case node['platform']
when "debian","ubuntu"
  apt_package node[cookbook_name]['pkg_name'] do
    action :install
  end
when "redhat","centos"
  yum_package node[cookbook_name]['pkg_name'] do
    action :install
  end

  execute "seboolean" do
    command "setsebool httpd_can_network_connect on -P"
    user 'root'
    group 'root'
    only_if "/usr/sbin/getsebool httpd_can_network_connect | /usr/bin/grep off"
  end
end

service "tomcat" do
  service_name node['tomcat']['pkg_name']
  supports :status => true, :restart => true
  action [ :enable, :nothing ]
end

include_recipe "tomcat::monit"
