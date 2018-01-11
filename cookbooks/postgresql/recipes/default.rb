data_dir = node[cookbook_name]['datadir']
cfg_dir = node[cookbook_name]['cfgdir']
conf_file = File.join(cfg_dir, 'pg_hba.conf')

case node['platform']
when "debian","ubuntu"
  apt_package node[cookbook_name]['pkg_name'] do
    action :install
  end

  apt_package 'python-psycopg2' do
    action :install
  end
when "redhat","centos"
  yum_package node[cookbook_name]['pkg_name'] do
    action :install
  end

  yum_package 'python-psycopg2' do
    action :install
  end

  execute 'initdb' do
    command "/usr/bin/initdb -D #{data_dir}"
    user node[cookbook_name]['user']
    group node[cookbook_name]['group']
    not_if { File.exists?(conf_file) }
  end
end

cookbook_file conf_file do
  source 'pg_hba.conf'
  owner node[cookbook_name]['user']
  group node[cookbook_name]['group']
  mode '0600'
  notifies :restart, "service[postgresql]"
end

service 'postgresql' do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

include_recipe "#{cookbook_name}::monit"
