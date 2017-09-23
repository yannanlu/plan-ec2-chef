
default['tomcat']['port'] = '8080'
default['tomcat']['bind_ip'] = '127.0.0.1'
default['tomcat']['webapp_context'] = nil

case node['platform']
when "debian","ubuntu"
  default['tomcat']['pkg_name'] = 'tomcat7'
  default['tomcat']['pkg_version'] = '7.0.68-1ubuntu0.1'
  default['tomcat']['dir'] = '/etc/tomcat7'
  default['tomcat']['basedir'] = '/var/lib/tomcat7'
  default['tomcat']['logdir'] = '/var/log/tomcat7'
  default['tomcat']['user'] = 'tomcat7'
  default['tomcat']['group'] = 'tomcat7'
when "redhat","centos"
  default['tomcat']['pkg_name'] = 'tomcat'
  default['tomcat']['pkg_version'] = '7.0.76-2.el7'
  default['tomcat']['dir'] = '/etc/tomcat'
  default['tomcat']['basedir'] = '/usr/share/tomcat'
  default['tomcat']['logdir'] = '/var/log/tomcat'
  default['tomcat']['user'] = 'tomcat'
  default['tomcat']['group'] = 'tomcat'
else
  default['tomcat']['pkg_name'] = 'tomcat'
  default['tomcat']['pkg_version'] = nil
  default['tomcat']['dir'] = '/etc/tomcat'
  default['tomcat']['basedir'] = '/usr/share/tomcat'
  default['tomcat']['logdir'] = '/var/log/tomcat'
  default['tomcat']['user'] = 'tomcat'
  default['tomcat']['group'] = 'tomcat'
end
