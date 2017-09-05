redis_dir = node[cookbook_name]['dir']

package node[cookbook_name]['pkg_name'] do
  version node[cookbook_name]['pkg_version']
  action :install
end

template File.join(redis_dir, "redis.conf") do
  owner "root"
  group "root"
  mode "0644"
  source "redis.conf.erb"
  notifies :restart, "service[redis]"
end

service "redis" do
  service_name node[cookbook_name]['pkg_name']
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

include_recipe "#{cookbook_name}::monit"
