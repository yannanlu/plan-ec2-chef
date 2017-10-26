pkg_list = node['common']['pkg_list']

pkg_list.each do |pkg|
  package pkg do
    action :install
  end
end

template '/etc/sysctl.conf' do
  source 'sysctl.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :list => node['common']['sysctl_props']
  )
  only_if { node['common']['sysctl_props'].length > 0 }
  notifies :run, "execute[common_sysctl]", :immediately
end

execute "common_sysctl" do
  command "sysctl -p"
  user 'root'
  group 'root'
  action :nothing
end
