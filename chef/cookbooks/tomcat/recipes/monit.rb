include_recipe "monit::default"

template File.join(node['monit']['includedir'], "tomcat.monit") do
  owner "root"
  group "root"
  mode 0644
  source "tomcat.monit.erb"
  variables(
    :pattern => ".base=#{node['tomcat']['basedir']} ",
    :start_program => "/usr/bin/systemctl start #{node['tomcat']['pkg_name']}",
    :stop_program => "/usr/bin/systemctl stop #{node['tomcat']['pkg_name']}"
  )
  notifies :restart, "service[monit]"
end
