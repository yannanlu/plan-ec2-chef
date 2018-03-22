include_recipe "java::default"

tmp = Chef::Config[:file_cache_path]
artifact = node[cookbook_name]['artifact']
url = "#{node[cookbook_name]['repo_url']}/#{artifact}"
qbroker_dir = node[cookbook_name]['dir']

group node[cookbook_name]['group'] do
  action :create
end

user node[cookbook_name]['user'] do
  action :create
  group node[cookbook_name]['group']
  shell '/sbin/nologin'
  manage_home false
end

directory qbroker_dir do
  owner node[cookbook_name]['user']
  group node[cookbook_name]['group']
  mode  '0755'
  action :create
end

execute "qb_get" do
  command "aws s3 --region #{node[cookbook_name]['aws_region']} cp #{url} #{tmp}"
  not_if { File.exists?(File.join(tmp, artifact)) }
  notifies :run, "execute[qb_tarball]", :immediately
end

execute "qb_tarball" do
  command "tar zxf #{tmp}/#{artifact}"
  user node[cookbook_name]['user']
  group node[cookbook_name]['group']
  cwd File.dirname(qbroker_dir)
  action :nothing
end

directory node[cookbook_name]['logdir'] do
  owner node[cookbook_name]['user']
  group node[cookbook_name]['group']
  mode  '0755'
  action :create
end

%w{.status archive checkpoint stats}.each do |dir|
  directory File.join(node[cookbook_name]['logdir'], dir) do
    owner node[cookbook_name]['user']
    group node[cookbook_name]['group']
    mode  '0755'
    action :create
  end
end

if node[cookbook_name]['security_plugin'] != nil
  plugin = node[cookbook_name]['security_plugin']
  url = "#{node[cookbook_name]['repo_url']}/#{plugin}"
  execute "qb_security_plugin_get" do
    command "aws s3 --region #{node[cookbook_name]['aws_region']} cp #{url} #{tmp}"
    not_if { File.exists?(File.join(tmp, plugin)) }
  end

  remote_file File.join(qbroker_dir, 'lib', plugin) do
    source "file://#{File.join(tmp, plugin)}"
    owner node[cookbook_name]['user']
    group node[cookbook_name]['group']
    mode '0644'
  end
end
