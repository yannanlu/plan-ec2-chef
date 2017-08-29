include_recipe "monit::default"

template File.join(node['monit']['includedir'], "redis.monit") do
  owner "root"
  group "root"
  mode 0644
  source "redis.monit.erb"
  variables(
    :start_program => '/usr/bin/systemctl start redis-server',
    :stop_program => '/usr/bin/systemctl stop redis-server'
  )
  notifies :restart, "service[monit]"
end
