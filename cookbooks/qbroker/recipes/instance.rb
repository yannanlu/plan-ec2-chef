include_recipe "#{cookbook_name}"

qbroker_dir = node[cookbook_name]['dir']
id = node[cookbook_name]['service_id']
json_files = node[cookbook_name]['json_files']

directory File.join(qbroker_dir, 'flow', id) do
  owner node[cookbook_name]['user']
  group node[cookbook_name]['group']
  mode '0755'
end

if node[cookbook_name]['wrapper_cookbook'] != nil
  json_files.each do |f|
    cookbook_file File.join(qbroker_dir, 'flow', id, f) do
      cookbook node[cookbook_name]['wrapper_cookbook']
      source "flow/#{f}"
      owner node[cookbook_name]['user']
      group node[cookbook_name]['group']
      mode '0644'
      notifies :restart, "service[#{cookbook_name}]"
    end
  end
end

template ::File.join(qbroker_dir, 'bin', "QFlow_#{id}.sh") do
  source "QFlow.sh.erb"
  owner node[cookbook_name]['user']
  group node[cookbook_name]['group']
  mode 0755
  variables(
    :id => id,
    :qb_dir => qbroker_dir,
    :java_opts => node[cookbook_name]['java_opts'],
    :jar_files => node[cookbook_name]['jar_files'],
    :log_dir => node[cookbook_name]['logdir']
  )
end

template ::File.join(qbroker_dir, 'init.d', "S50QFlow_#{id}") do
  source "QFlow.init.erb"
  owner node[cookbook_name]['user']
  group node[cookbook_name]['group']
  mode 0755
  variables(
    :id => id,
    :qb_user => node[cookbook_name]['user'],
    :qb_dir => qbroker_dir
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
    :qb_user => node[cookbook_name]['user'],
    :qb_group => node[cookbook_name]['group'],
    :qb_dir => qbroker_dir
  )
end

service "qbroker" do
  supports :status => true, :restart => true
  action [ :enable, :nothing ]
end

include_recipe "#{cookbook_name}::monit"
