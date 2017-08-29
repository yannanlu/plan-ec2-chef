default['nginx']['dir']     = "/etc/nginx"
default['nginx']['log_dir'] = "/var/log/nginx"
default['nginx']['pidfile'] = "/var/run/nginx.pid"

case node['platform']
when "debian","ubuntu"
  default['nginx']['user']  = "www-data"
  default['nginx']['group'] = "www-data"
when "redhat","centos"
  default['nginx']['user']  = "nginx"
  default['nginx']['group'] = "nginx"
else
  default['nginx']['user']  = "nginx"
  default['nginx']['group'] = "nginx"
end

default['nginx']['keepalive_requests'] = 10
default['nginx']['keepalive_timeout']  = 10
