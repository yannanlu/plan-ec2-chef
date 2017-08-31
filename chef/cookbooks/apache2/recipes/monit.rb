include_recipe "monit::default"

service_name = node[cookbook_name]['pkg_name']

template File.join(node['monit']['includedir'], "#{cookbook_name}.monit") do
  owner "root"
  group "root"
  mode 0644
  source "#{cookbook_name}.monit.erb"
  variables(
    :pidfile => node[cookbook_name]['pidfile'],
    :start_program => "/usr/bin/systemctl start #{service_name}",
    :stop_program => "/usr/bin/systemctl stop #{service_name}"
  )
  notifies :restart, "service[monit]"
end
