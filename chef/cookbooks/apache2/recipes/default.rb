pkg_name = node['apache2']['pkg_name']

package pkg_name do
  action :install
end

case node['platform']
when "redhat","centos"
  package 'mod_ssl' do
    action :install
  end
end

service "apache2" do
  service_name pkg_name
  supports :status => true, :restart => true
  action [:enable, :nothing]
end

include_recipe "#{cookbook_name}::monit"
