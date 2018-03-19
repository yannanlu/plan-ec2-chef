case node['platform']
when "debian","ubuntu"
  apt_package node[cookbook_name]['pkg_name'] do
    action :install
  end
when "redhat","centos"
  yum_package node[cookbook_name]['pkg_name'] do
    action :install
  end
end

cookbook_file File.join(node[cookbook_name]['includedir'], "monit.pem") do
  owner "root"
  group "root"
  mode "0600"
  source "monit.pem"
  notifies :restart, "service[monit]"
end

template File.join(node[cookbook_name]['dir'], "monitrc") do
  owner "root"
  group "root"
  mode 0600
  source "monitrc.erb"
  notifies :restart, "service[monit]"
end

template File.join(node[cookbook_name]['includedir'], "os_release.monit") do
  owner "root"
  group "root"
  mode 0644
  source "os_release.monit.erb"
  variables(
    :release_file => node[cookbook_name]['os_release_file']
  )
end

service cookbook_name do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
