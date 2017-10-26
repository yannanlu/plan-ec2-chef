include_recipe "monit::default"

template File.join(node['monit']['includedir'], "#{cookbook_name}.monit") do
  owner "root"
  group "root"
  mode 0644
  source "#{cookbook_name}.monit.erb"
  variables(
    :pattern => node[cookbook_name]['pattern'],
    :pidfile => node[cookbook_name]['pidfile']
  )
  notifies :restart, "service[monit]"
end
