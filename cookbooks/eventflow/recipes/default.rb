node.override['qbroker']['wrapper_cookbook'] = cookbook_name
node.override['qbroker']['service_id'] = cookbook_name.sub(/flow$/, '').upcase
if node[cookbook_name]['security_plugin'] != nil
  node.override['qbroker']['security_plugin']=node[cookbook_name]['security_plugin']
end

# json files
node.override['qbroker']['json_files'] = node[cookbook_name]['json_files']

# jar files
node.override['qbroker']['jar_files'] = node[cookbook_name]['jar_files']

include_recipe "qbroker::instance"

qbroker_dir = node['qbroker']['dir']
id = node['qbroker']['service_id']
service = node[cookbook_name]['log_location']['service']
log_file = File.join(node['nginx']['logdir'], "#{service}.log")
es_url = "http://#{node['elasticsearch']['bind_ip']}:#{node['elasticsearch']['port']}/"

template File.join(qbroker_dir, 'flow', id, 'Flow.json') do
  source 'Flow.json.erb'
  owner node['qbroker']['user']
  group node['qbroker']['group']
  mode '0644'
  variables(
    :id => id,
    :qb_dir => qbroker_dir,
    :log_dir => node['qbroker']['logdir']
  )
  notifies :restart, "service[qbroker]"
end

template File.join(qbroker_dir, 'flow', id, 'rpt_global_var.json') do
  source 'rpt_global_var.json.erb'
  owner node['qbroker']['user']
  group node['qbroker']['group']
  mode '0644'
  variables(
    :log_dir => node['qbroker']['logdir'],
    :log_file => log_file,
    :es_url => es_url
  )
  notifies :restart, "service[qbroker]"
end

locations = []
locations.push(node[cookbook_name]['log_location'])
node.override['nginx']['log_locations'] = locations
node.override['nginx']['extra_server'] = node[cookbook_name]['extra_server']

include_recipe "nginx"

key = node[cookbook_name]['es_template']
node.override['elasticsearch']['index_template'][key] = cookbook_name

include_recipe "elasticsearch"
