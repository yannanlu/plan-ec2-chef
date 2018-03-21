pkg_list = node['common']['pkg_list']

pkg_list.each do |pkg|
  package pkg do
    action :install
  end
end

execute "common_awscli" do
  command "pip install awscli"
  user 'root'
  group 'root'
  not_if "which aws"
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

if node['common']['swap_size'].to_i > 0
  execute "common_swap_file" do
    command "dd if=/dev/zero of=/swapfile count=#{node['common']['swap_size']} bs=1MiB"
    user 'root'
    group 'root'
    not_if "swapon -s | grep swapfile"
    notifies :run, "execute[common_swap]", :immediately
  end

  execute "common_swap" do
    command "chmod 0600 /swapfile && mkswap /swapfile && swapon /swapfile"
    user 'root'
    group 'root'
    action :nothing
  end
end
