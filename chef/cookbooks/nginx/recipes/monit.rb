include_recipe "monit::default"

template File.join(node['monit']['includedir'], "nginx.monit") do
  owner "root"
  group "root"
  mode 0644
  source "nginx.monit.erb"
  variables(
    :start_program => '/usr/bin/systemctl start nginx',
    :stop_program => '/usr/bin/systemctl stop nginx'
  )
  notifies :restart, "service[monit]"
end
