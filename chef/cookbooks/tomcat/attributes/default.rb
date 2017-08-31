
default['tomcat']['port'] = '8080'
default['tomcat']['bind_ip'] = '127.0.0.1'

case node['platform']
when "debian","ubuntu"
  default['tomcat']['dir'] = '/etc/tomcat7'
  default['tomcat']['basedir'] = '/var/lib/tomcat7'
  default['tomcat']['logdir'] = '/var/log/tomcat7'
  default['tomcat']['pkg_name'] = 'tomcat7'
  default['tomcat']['user'] = 'tomcat7'
  default['tomcat']['group'] = 'tomcat7'
when "redhat","centos"
  default['tomcat']['dir'] = '/etc/tomcat'
  default['tomcat']['basedir'] = '/usr/share/tomcat'
  default['tomcat']['logdir'] = '/var/log/tomcat'
  default['tomcat']['pkg_name'] = 'tomcat'
  default['tomcat']['user'] = 'tomcat'
  default['tomcat']['group'] = 'tomcat'
else
  default['tomcat']['dir'] = '/etc/tomcat'
  default['tomcat']['basedir'] = '/usr/share/tomcat'
  default['tomcat']['logdir'] = '/var/log/tomcat'
  default['tomcat']['pkg_name'] = 'tomcat'
  default['tomcat']['user'] = 'tomcat'
  default['tomcat']['group'] = 'tomcat'
end
