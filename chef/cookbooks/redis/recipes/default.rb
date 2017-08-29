redis_dir = node['redis']['dir']

package "redis-server" do
  action :install
  notifies :restart, "service[redis]"
end

template File.join(redis_dir, "redis.conf") do
  owner "root"
  group "root"
  mode "0644"
  source "redis.conf.erb"
  notifies :restart, "service[redis]"
end

service "redis" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

include_recipe "redis::monit"
