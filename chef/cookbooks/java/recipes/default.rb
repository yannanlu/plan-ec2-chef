case node['platform']
when "debian","ubuntu"
  apt_package node[cookbook_name]['pkg_name'] do
    version node[cookbook_name]['pkg_version']
    action :install
  end
when "redhat","centos"
  yum_package node[cookbook_name]['pkg_name'] do
    version node[cookbook_name]['pkg_version']
    action :install
  end
end
