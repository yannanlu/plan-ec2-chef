include_recipe "java::default"

case node['platform']
when "debian","ubuntu"
  apt_repository cookbook_name do
    uri node[cookbook_name]['repo_uri']
    key node[cookbook_name]['gpg_key']
    distribution node[cookbook_name]['distribution']
    components node[cookbook_name]['components']
    action :add
  end

  apt_package node[cookbook_name]['pkg_name'] do
    action :install
  end
when "redhat","centos"
  yum_repository cookbook_name do
    description "Elasticsearch repo"
    baseurl node[cookbook_name]['repo_uri']
    gpgkey node[cookbook_name]['gpg_key']
    action :create
  end

  yum_package node[cookbook_name]['pkg_name'] do
    flush_cache [ :before ]
    action :install
  end
end

template File.join(node[cookbook_name]['dir'], "jvm.options") do
  source "jvm.options.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :heapsize => node[cookbook_name]['heapsize']
  )
  notifies :restart, "service[#{cookbook_name}]"
end

service cookbook_name do
  service_name node[cookbook_name]['pkg_name']
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

execute "elasticsearch_pause" do
  command "sleep #{node[cookbook_name]['pausetime']}"
  not_if "curl -s http://localhost:#{node[cookbook_name]['port']}/?pretty"
end

tmp = Chef::Config[:file_cache_path]
node[cookbook_name]['index_template'].each do |tp, cb|
  tmp_file = File.join(tmp, "#{tp}.json")
  cookbook_file tmp_file do
    cookbook cb
    source "#{tp}.json"
    mode '0644'
  end

  execute "es_index_#{tp}" do
    command "curl -XPUT -s http://localhost:#{node[cookbook_name]['port']}/_template/#{tp} -H 'Content-Type: application/json' -d @#{tmp_file}"
    not_if "curl -I -s http://localhost:#{node[cookbook_name]['port']}/_template/#{tp} | grep ' 200 OK'"
  end
end

include_recipe "#{cookbook_name}::monit"
