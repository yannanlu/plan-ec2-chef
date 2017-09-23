case node['platform']
when "debian","ubuntu"
  default['apache2']['pkg_name']  = 'apache2'
  default['apache2']['pkg_version']  = '2.4.18-2ubuntu3.5'
  default['apache2']['dir'] = '/etc/apache2'
  default['apache2']['modsdir'] = '/usr/lib/apache2/modules'
  default['apache2']['pidfile'] = '/var/run/apache2/apache2.pid'
  default['apache2']['logdir'] = '/var/log/apache2'
  default['apache2']['user']  = 'www-data'
  default['apache2']['group'] = 'www-data'
when "redhat","centos"
  default['apache2']['pkg_name']  = 'httpd'
  default['apache2']['pkg_version']  = '2.4.6-67.el7.centos.2'
  default['apache2']['dir'] = '/etc/httpd'
  default['apache2']['modsdir'] = '/etc/httpd/modules'
  default['apache2']['pidfile'] = '/var/run/httpd/httpd.pid'
  default['apache2']['logdir'] = '/var/log/httpd'
  default['apache2']['user']  = 'apache'
  default['apache2']['group'] = 'apache'
else
  default['apache2']['pkg_name']  = 'httpd'
  default['apache2']['pkg_version']  = nil
  default['apache2']['dir'] = '/etc/httpd'
  default['apache2']['modsdir'] = '/etc/httpd/modules'
  default['apache2']['pidfile'] = '/var/run/httpd/httpd.pid'
  default['apache2']['logdir'] = '/var/log/httpd'
  default['apache2']['user']  = 'apache'
  default['apache2']['group'] = 'apache'
end
