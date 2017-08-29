include_recipe "qbroker"

qbroker_dir = File.join(node['qbroker']['basedir'], cookbook_name)
id = node['qbroker']['service_id']
json_files = node['qbroker']['json_files']

directory File.join(qbroker_dir, 'flow', id) do
  owner node['qbroker']['user']
  group node['qbroker']['group']
  mode '0755'
end

if node['qbroker']['wrapper_cookbook'] != nil
  json_files.each do |f|
    cookbook_file File.join(qbroker_dir, 'flow', id, f) do
      cookbook node['qbroker']['wrapper_cookbook']
      source "flow/#{f}"
      owner node['qbroker']['user']
      group node['qbroker']['group']
      mode '0644'
      notifies :restart, "service[qbroker]"
    end
  end
end

template ::File.join(qbroker_dir, 'bin', "QFlow_#{id}.sh") do
  source "QFlow.sh.erb"
  owner node['qbroker']['user']
  group node['qbroker']['group']
  mode 0755
  variables(
    :id => id,
    :user => node['qbroker']['user'],
    :homedir => qbroker_dir,
    :javaopts => node['qbroker']['javaopts'],
    :jarfiles => jarfiles,
    :logdir => node['qbroker']['logdir']
  )
end

template ::File.join(qbroker_dir, 'init.d', "S50QFlow_#{id}") do
  source "QFlow.init.erb"
  owner node['qbroker']['user']
  group node['qbroker']['group']
  mode 0755
  variables(
    :id => id,
    :user => node['qbroker']['user'],
    :homedir => qbroker_dir
  )
end

case node['platform']
when "debian","ubuntu"
  systemd_dir = '/lib/systemd/system'
when "redhat","centos"
  systemd_dir = '/usr/lib/systemd/system'
else
  systemd_dir = '/usr/lib/systemd/system'
end

template File.join(systemd_dir, 'qbroker.service') do
  source 'qbroker.service.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :id => id,
    :user => node['qbroker']['user'],
    :group => node['qbroker']['group'],
    :homedir => qbroker_dir
  )
end

service "qbroker" do
  supports :status => true, :restart => true
  action [ :enable, :nothing ]
end
