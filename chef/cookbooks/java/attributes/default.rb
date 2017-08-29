case node['platform']
when "debian","ubuntu"
  default['java']['pkg_name'] = "openjdk-8-jdk"
when "redhat","centos"
  default['java']['pkg_name'] = "java-1.8.0-openjdk.x86_64"
else
  default['java']['pkg_name'] = "java-1.8.0-openjdk.x86_64"
end
