include_recipe "monit::default"

template File.join(node['monit']['includedir'], "activemq.monit") do
  owner "root"
  group "root"
  mode 0644
  source "activemq.monit.erb"
  variables(
    :pidfile => "/opt/activemq/data/activemq.pid",
    :start_program => "/usr/bin/systemctl start activemq",
    :stop_program => "/usr/bin/systemctl stop activemq"
  )
  notifies :restart, "service[monit]"
end
