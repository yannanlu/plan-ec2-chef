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
    notifies :restart, "service[#{cookbook_name}]"
  end
when "redhat","centos"
  cookbook_file File.join("/etc/yum.repos.d", "#{cookbook_name}.repo") do
    owner "root"
    group "root"
    mode "0644"
    source "#{cookbook_name}.repo"
  end

  yum_package node[cookbook_name]['pkg_name'] do
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
    notifies :restart, "service[#{cookbook_name}]"
  end
end

service cookbook_name do
  service_name node[cookbook_name]['pkg_name']
  supports :status => true, :restart => true
  action [ :enable, :restart ]
end

include_recipe "#{cookbook_name}::monit"
