default['nginx']['dir']     = '/etc/nginx'
default['nginx']['logdir'] = '/var/log/nginx'
default['nginx']['pidfile'] = '/var/run/nginx.pid'
default['nginx']['locations'] = []
default['nginx']['log_locations'] = []
default['nginx']['extra_server'] = {}

case node['platform']
when "debian","ubuntu"
  default['nginx']['pkg_name']  = 'nginx'
  default['nginx']['pkg_version']  = '1.10.3-0ubuntu0.16.04.2'
  default['nginx']['user']  = 'www-data'
  default['nginx']['group'] = 'www-data'
when "redhat","centos"
  default['nginx']['pkg_name']  = 'nginx'
  default['nginx']['pkg_version']  = '1.10.2-1.el7'
  default['nginx']['user']  = 'nginx'
  default['nginx']['group'] = 'nginx'
else
  default['nginx']['pkg_name']  = 'nginx'
  default['nginx']['pkg_version']  = nil
  default['nginx']['user']  = 'nginx'
  default['nginx']['group'] = 'nginx'
end
