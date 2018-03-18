include_recipe "java::default"

case node['platform']
when "debian","ubuntu"
  apt_package node[cookbook_name]['pkg_name'] do
    action :install
  end

  template File.join("/etc/default", cookbook_name) do
    source "#{cookbook_name}.erb"
    owner "root"
    group "root"
    mode "0644"
    variables(
      :heapsize => node[cookbook_name]['heapsize']
    )
    notifies :restart, "service[#{cookbook_name}]", :immediately
  end
when "redhat","centos"
  yum_repository cookbook_name do
    description "Elasticsearch 6.x repo"
    baseurl node[cookbook_name]['repo_uri']
    gpgkey node[cookbook_name]['gpg_key']
    action :create
  end

  yum_package node[cookbook_name]['pkg_name'] do
    flush_cache [ :before ]
    action :install
  end

  template File.join(node[cookbook_name]['dir'], "jvm.options") do
    source "jvm.options.erb"
    owner "root"
    group "root"
    mode "0644"
    variables(
      :heapsize => node[cookbook_name]['heapsize']
    )
    notifies :restart, "service[#{cookbook_name}]", :immediately
  end
end

service cookbook_name do
  service_name node[cookbook_name]['pkg_name']
  supports :status => true, :restart => true
  action [ :enable, :start ]
  notifies :run, "execute[elasticsearch_pause]", :immediately
end

execute "elasticsearch_pause" do
  command "sleep 10"
  action :nothing
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
    command "curl -XPUT -s http://localhost:#{node[cookbook_name]['port']}/_template/#{tp} -d @#{tmp_file}"
    not_if "curl -I -s http://localhost:#{node[cookbook_name]['port']}/_template/#{tp} | grep ' 200 OK'"
  end
end

include_recipe "#{cookbook_name}::monit"
