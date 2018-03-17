include_recipe "monit::default"

template File.join(node['monit']['includedir'], "#{cookbook_name}.monit") do
  owner "root"
  group "root"
  mode 0644
  source "#{cookbook_name}.monit.erb"
  variables(
    :id => node[cookbook_name]['service_id'],
    :qb_dir => node[cookbook_name]['dir']
  )
  notifies :restart, "service[monit]"
end
