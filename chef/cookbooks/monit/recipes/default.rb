package "monit" do
  action :install
end

cookbook_file File.join(node['monit']['includedir'], "monit.pem") do
  owner "root"
  group "root"
  mode "0600"
  source "monit.pem"
  notifies :restart, "service[monit]"
end

template File.join(node['monit']['dir'], "monitrc") do
  owner "root"
  group "root"
  mode 0600
  source "monitrc.erb"
  notifies :restart, "service[monit]"
end

service "monit" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
