include_recipe "monit::default"

template File.join(node['monit']['includedir'], "#{cookbook_name}.monit") do
  owner "root"
  group "root"
  mode 0644
  source "#{cookbook_name}.monit.erb"
  variables(
    :pidfile => node[cookbook_name]['pidfile'],
    :start_program => "/usr/bin/systemctl start #{cookbook_name}",
    :stop_program => "/usr/bin/systemctl stop #{cookbook_name}"
  )
  notifies :restart, "service[monit]"
end
