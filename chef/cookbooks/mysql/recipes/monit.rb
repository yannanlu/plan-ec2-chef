include_recipe "monit::default"

template File.join(node['monit']['includedir'], "#{cookbook_name}d.monit") do
  owner "root"
  group "root"
  mode 0644
  source "#{cookbook_name}d.monit.erb"
  variables(
    :pidfile => node[cookbook_name]['pidfile']
  )
  notifies :restart, "service[monit]"
end
