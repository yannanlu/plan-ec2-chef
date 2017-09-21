webapp_context = node['qbroker']['webapp_context']
if webapp_context != nil
  node.override['tomcat']['webapp_context'] = webapp_context
end

include_recipe "tomcat"
include_recipe "qbroker"

qbroker_dir = File.join(node['qbroker']['basedir'], cookbook_name)
id = node['qbroker']['service_id']
jsp_files = node['qbroker']['jsp_files']
jar_files = node['qbroker']['jar_files']
json_files = node['qbroker']['json_files']
tomcat_dir = node['tomcat']['dir']

directory File.join(qbroker_dir, 'flow', id) do
  owner node['qbroker']['user']
  group node['qbroker']['group']
  mode '0755'
end

template File.join(tomcat_dir, 'web.xml') do
  source 'web.xml.erb'
  owner 'root'
  group node['tomcat']['group']
  mode '0644'
  variables( :is_readonly => 'false' )
  notifies :restart, "service[tomcat]"
end

template File.join(tomcat_dir, 'Catalina', 'localhost', "#{webapp_context}.xml") do
  source 'context.xml.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :path => webapp_context,
    :context => webapp_context,
    :dir => qbroker_dir
  )
  notifies :restart, "service[tomcat]"
end

[ webapp_context, "#{webapp_context}/WEB-INF", "#{webapp_context}/WEB-INF/lib" ].each do |dir|
  directory File.join(qbroker_dir, dir) do
    owner node['tomcat']['user']
    group node['tomcat']['group']
    mode '0755'
  end
end

jar_files.each do |f|
  remote_file File.join(qbroker_dir, webapp_context, 'WEB-INF', 'lib', f) do
    source "file://#{File.join(qbroker_dir, 'lib', f)}"
    owner node['tomcat']['user']
    group node['tomcat']['group']
    mode '0644'
  end
end

## copy files over from the wrapper cookbook
if node['qbroker']['wrapper_cookbook'] != nil
  json_files.each do |f|
    cookbook_file File.join(qbroker_dir, 'flow', id, f) do
      cookbook node['qbroker']['wrapper_cookbook']
      source "flow/#{f}"
      owner node['qbroker']['user']
      group node['qbroker']['group']
      mode '0644'
      notifies :restart, "service[tomcat]"
    end
  end

  cookbook_file File.join(qbroker_dir, webapp_context, 'WEB-INF', 'web.xml') do
    cookbook node['qbroker']['wrapper_cookbook']
    source 'web.xml'
    owner node['tomcat']['user']
    group node['tomcat']['group']
    mode '0644'
  end

  jsp_files.each do |f|
    cookbook_file File.join(qbroker_dir, webapp_context, f) do
      cookbook node['qbroker']['wrapper_cookbook']
      source "jsp/#{f}"
      owner node['tomcat']['user']
      group node['tomcat']['group']
      mode '0644'
    end
  end
end
