include_recipe "monit::default"

service_name = node[cookbook_name]['pkg_name']
basedir = node[cookbook_name]['basedir']
webapp_context = node[cookbook_name]['webapp_context']
template File.join(node['monit']['includedir'], "#{cookbook_name}.monit") do
  owner "root"
  group "root"
  mode 0644
  source "#{cookbook_name}.monit.erb"
  variables(
    :pattern => ".base=#{basedir} ",
    :start_program => "/usr/bin/systemctl start #{service_name}",
    :stop_program => "/usr/bin/systemctl stop #{service_name}",
    :webapp_context => webapp_context
  )
  notifies :restart, "service[monit]"
end
