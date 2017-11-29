include_recipe "java::default"

tmp = Chef::Config[:file_cache_path]
artifact = node['qbroker']['artifact']
url = "#{node['qbroker']['repo_url']}/#{artifact}"
qbroker_dir = File.join(node['qbroker']['basedir'], cookbook_name)

#Chef::Log.info "#{tmp}: #{url}"

group node['qbroker']['group'] do
  action :create
end

user node['qbroker']['user'] do
  action :create
  group node['qbroker']['group']
  shell '/sbin/nologin'
  manage_home false
end

directory qbroker_dir do
  owner node['qbroker']['user']
  group node['qbroker']['group']
  mode  '0755'
  action :create
end

#execute "qb_get" do
#  command "curl -kO #{url}"
#  cwd tmp
#  not_if { File.exists?(File.join(tmp, artifact)) }
#  notifies :run, "execute[qb_tarball]", :immediately
#end

execute "qb_get" do
  command "aws s3 cp #{url} #{tmp}"
  not_if { File.exists?(File.join(tmp, artifact)) }
  notifies :run, "execute[qb_tarball]", :immediately
end

execute "qb_tarball" do
  command "tar zxf #{tmp}/#{artifact}"
  user node['qbroker']['user']
  group node['qbroker']['group']
  cwd node['qbroker']['basedir']
  action :nothing
end

directory node['qbroker']['logdir'] do
  owner node['qbroker']['user'] 
  group node['qbroker']['group']
  mode  '0755'
  action :create
end

%w{.status archive checkpoint stats}.each do |dir|
  directory File.join(node['qbroker']['logdir'], dir) do
    owner node['qbroker']['user'] 
    group node['qbroker']['group']
    mode  '0755'
    action :create
  end
end
