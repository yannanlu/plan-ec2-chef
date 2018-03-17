node.override['qbroker']['webapp_context'] = cookbook_name
node.override['qbroker']['wrapper_cookbook'] = cookbook_name
node.override['qbroker']['service_id'] = cookbook_name.sub(/service$/,'').upcase
if node['idservice']['security_plugin'] != nil
  node.override['qbroker']['security_plugin']=node['idservice']['security_plugin']
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

template File.join(qbroker_dir, 'flow', id, 'node_collect.json') do
  source 'node_collect.json.erb'
  owner node['qbroker']['user']
  group node['qbroker']['group']
  mode '0644'
  variables(
    :db_type => node[cookbook_name]['db_type']
  )
  notifies :restart, "service[tomcat]"
end

template File.join(qbroker_dir, 'flow', id, 'pstr_db_query.json') do
  source 'pstr_db_query.json.erb'
  owner node['qbroker']['user']
  group node['qbroker']['group']
  mode '0644'
  variables(
    :db_type => node[cookbook_name]['db_type'],
    :db_name => node[cookbook_name]['db_name'],
    :db_user => node[cookbook_name]['db_user'],
    :db_passwd => node[cookbook_name]['db_passwd']
  )
  notifies :restart, "service[tomcat]"
end
