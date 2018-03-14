redis_dir = node[cookbook_name]['dir']

package node[cookbook_name]['pkg_name'] do
  action :install
end

template File.join(redis_dir, "redis.conf") do
  owner node[cookbook_name]['user']
  group "root"
  mode "0644"
  source "redis.conf.erb"
  variables(
    :port => node[cookbook_name]['port'],
    :bind_ip => node[cookbook_name]['bind_ip'],
    :db_dir => node[cookbook_name]['db_dir'],
    :pidfile => node[cookbook_name]['pidfile'],
    :logfile => node[cookbook_name]['logfile'],
    :log_level => node[cookbook_name]['log_level']
  )
  notifies :restart, "service[redis]"
end

service "redis" do
  service_name node[cookbook_name]['pkg_name']
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

include_recipe "#{cookbook_name}::monit"
