data_dir = node[cookbook_name]['datadir']
cfg_dir = node[cookbook_name]['cfgdir']
conf_file = File.join(cfg_dir, 'pg_hba.conf')

case node['platform']
when "debian","ubuntu"
  %w{postgresql python-psycopg2}.each do |pkg|
    package pkg do
      action :install
    end
  end
when "redhat","centos"
  %w{postgresql-server python-psycopg2}.each do |pkg|
    package pkg do
      action :install
    end
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
