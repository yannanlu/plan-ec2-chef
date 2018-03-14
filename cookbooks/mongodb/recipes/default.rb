case node['platform']
when "debian","ubuntu"
  apt_repository 'repo_mongodb' do
    uri node[cookbook_name]['repo_uri'] 
    key node[cookbook_name]['key_id']
    keyserver node[cookbook_name]['key_server']
    distribution node[cookbook_name]['distribution']
    components node[cookbook_name]['components']
    action :add
    notifies :update, "apt_update[mongodb]", :immediately
  end

  apt_update "mongodb" do
    action :nothing
  end

  apt_package node[cookbook_name]['pkg_name'] do
    action :install
  end
when "redhat","centos"
  yum_repository cookbook_name do
    description "MongoDB Repository"
    baseurl node[cookbook_name]['repo_uri'] 
    gpgkey node[cookbook_name]['gpg_key']
    action :create
  end

  yum_package node[cookbook_name]['pkg_name'] do
    flush_cache [ :before ]
    action :install
  end
end

template File.join(node[cookbook_name]['dir'], 'mongod.conf') do
  source 'mongod.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :port => node[cookbook_name]['port'],
    :bind_ip => node[cookbook_name]['bind_ip'],
    :dbpath => node[cookbook_name]['dbpath'],
    :pidfile => node[cookbook_name]['pidfile'],
    :logfile => node[cookbook_name]['logfile']
  )
  notifies :restart, "service[mongodb]"
end

service cookbook_name do
  service_name node[cookbook_name]['service_name']
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

include_recipe "#{cookbook_name}::monit"
