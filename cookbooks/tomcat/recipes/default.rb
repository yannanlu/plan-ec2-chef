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
    notifies :run, "execute[tomcat_se_permissive]", :immediately
  end

  execute "tomcat_se_permissive" do
    command "/usr/sbin/semanage permissive -a tomcat_t"
    user 'root'
    group 'root'
    action :nothing
    only_if { node[cookbook_name]['se_mode'] == 'permissive' }
  end
end

template File.join(node['tomcat']['dir'], 'web.xml') do
  source 'web.xml.erb'
  owner 'root'
  group node['tomcat']['group']
  mode '0644'
  variables( :is_readonly => node['tomcat']['is_readonly'] )
  notifies :restart, "service[tomcat]"
end

service "tomcat" do
  service_name node['tomcat']['pkg_name']
  supports :status => true, :restart => true
  action [ :enable, :nothing ]
end

include_recipe "tomcat::monit"
