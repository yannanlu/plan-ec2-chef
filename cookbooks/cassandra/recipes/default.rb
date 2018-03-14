include_recipe "java::default"

case node['platform']
when "debian","ubuntu"
  keyfile = File.join(Chef::Config[:file_cache_path],"#{cookbook_name}_gpg.key")
  remote_file keyfile do
    source node[cookbook_name]['gpg_key']
    mode "0644"
    not_if { File.exists?(keyfile) }
    notifies :run, "execute[cassandra_addkey]", :immediately
  end

  execute "cassandra_addkey" do
    command "apt-key add #{keyfile}"
    action :nothing
  end

  apt_repository 'repo_cassandra' do
    uri node[cookbook_name]['repo_uri'] 
    key node[cookbook_name]['key_id']
    keyserver node[cookbook_name]['key_server']
    distribution node[cookbook_name]['distribution']
    components node[cookbook_name]['components']
    action :add
  end

  apt_package node[cookbook_name]['pkg_name'] do
    action :install
  end
when "redhat","centos"
  yum_repository cookbook_name do
    description "Apache Cassandra"
    baseurl node[cookbook_name]['repo_uri']
    gpgkey node[cookbook_name]['gpg_key']
    action :create
  end

  yum_package node[cookbook_name]['pkg_name'] do
    flush_cache [ :before ]
    action :install
  end
end

template File.join(node[cookbook_name]['dir'], 'jvm.options') do
  source 'jvm.options.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :heapsize => node[cookbook_name]['heapsize']
  )
  notifies :restart, "service[cassandra]"
end

service cookbook_name do
  service_name node[cookbook_name]['pkg_name']
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

include_recipe "#{cookbook_name}::monit"
