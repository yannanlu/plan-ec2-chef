include_recipe "java::default"

package node['tomcat']['pkg_name'] do
  action :install
end

case node['platform']
when "redhat","centos"
  execute "seboolean" do
    command "setsebool httpd_can_network_connect on -P"
    user 'root'
    group 'root'
    only_if { "getsebool httpd_can_network_connect | grep off" }
  end
end

service "tomcat" do
  service_name node['tomcat']['pkg_name']
  supports :status => true, :restart => true
  action [ :enable, :nothing ]
end

include_recipe "tomcat::monit"
