case node['platform']
when "debian","ubuntu"
  default['java']['pkg_name'] = 'openjdk-8-jdk'
  default['java']['pkg_version'] = '8u131-b11-2ubuntu1.16.04.3' 
when "redhat","centos"
  default['java']['pkg_name'] = 'java-1.8.0-openjdk'
  default['java']['pkg_version'] = '1.8.0.144-0.b01.el7_4'
else
  default['java']['pkg_name'] = 'java-1.8.0-openjdk'
  default['java']['pkg_version'] = nil
end
