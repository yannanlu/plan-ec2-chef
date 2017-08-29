include_recipe "java::default"

tomcat_dir = node['tomcat']['dir']

package node['tomcat']['pkg_name'] do
  action :install
end

service "tomcat" do
  service_name node['tomcat']['pkg_name']
  supports :status => true, :restart => true
  action [ :enable, :nothing ]
end

include_recipe "tomcat::monit"
