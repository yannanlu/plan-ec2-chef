include_recipe "activemq"

node.override['tomcat']['is_readonly'] = 'false'
node.override['qbroker']['webapp_context'] = cookbook_name
node.override['qbroker']['wrapper_cookbook'] = cookbook_name
node.override['qbroker']['service_id'] = cookbook_name.sub(/service/, '').upcase
if node['mbservice']['security_plugin'] != nil
  node.override['qbroker']['security_plugin']=node['mbservice']['security_plugin']
end

# json files
node.override['qbroker']['json_files'] = node[cookbook_name]['json_files']

# jsp files
node.override['qbroker']['jsp_files'] = node[cookbook_name]['jsp_files']

# jar files
node.override['qbroker']['jar_files'] = node[cookbook_name]['jar_files']

include_recipe "qbroker::webapp"

qbroker_dir = node['qbroker']['dir']
id = node['qbroker']['service_id']

template File.join(qbroker_dir, 'flow', id, 'Flow.json') do
  source 'Flow.json.erb'
  owner node['qbroker']['user']
  group node['qbroker']['group']
  mode '0644'
  variables(
    :id => id,
    :qb_dir => qbroker_dir,
    :log_dir => node['tomcat']['logdir']
  )
  notifies :restart, "service[tomcat]"
end

template File.join(qbroker_dir, 'flow', id, 'pstr_msg.json') do
  source 'pstr_msg.json.erb'
  owner node['qbroker']['user']
  group node['qbroker']['group']
  mode '0644'
  variables(
    :url => "tcp://localhost:#{node['activemq']['broker_port']}",
    :context_factory => node['activemq']['context_factory'],
    :qcf => node['activemq']['queue_connection_factory'],
    :queue => 'MSG_OUT',
    :user => node['activemq']['broker_user'],
    :passwd => node['activemq']['broker_passwd']
  )
  notifies :restart, "service[tomcat]"
end
