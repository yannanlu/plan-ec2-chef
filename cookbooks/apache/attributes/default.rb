default['apache']['locations'] = []

case node['platform']
when "debian","ubuntu"
  default['apache']['pkg_name']  = 'apache2'
  default['apache']['pkg_version']  = '2.4.18-2ubuntu3.5'
  default['apache']['dir'] = '/etc/apache2'
  default['apache']['modsdir'] = '/usr/lib/apache2/modules'
  default['apache']['pidfile'] = '/var/run/apache2/apache2.pid'
  default['apache']['logdir'] = '/var/log/apache2'
  default['apache']['user']  = 'www-data'
  default['apache']['group'] = 'www-data'
when "redhat","centos"
  default['apache']['pkg_name']  = 'httpd'
  default['apache']['pkg_version']  = '2.4.6-67.el7.centos.2'
  default['apache']['dir'] = '/etc/httpd'
  default['apache']['modsdir'] = '/etc/httpd/modules'
  default['apache']['pidfile'] = '/var/run/httpd/httpd.pid'
  default['apache']['logdir'] = '/var/log/httpd'
  default['apache']['user']  = 'apache'
  default['apache']['group'] = 'apache'
else
  default['apache']['pkg_name']  = 'httpd'
  default['apache']['pkg_version']  = nil
  default['apache']['dir'] = '/etc/httpd'
  default['apache']['modsdir'] = '/etc/httpd/modules'
  default['apache']['pidfile'] = '/var/run/httpd/httpd.pid'
  default['apache']['logdir'] = '/var/log/httpd'
  default['apache']['user']  = 'apache'
  default['apache']['group'] = 'apache'
end
