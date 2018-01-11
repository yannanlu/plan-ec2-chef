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
