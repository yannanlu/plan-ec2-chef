default['redis']['port'] = '6379'
default['redis']['bind_ip'] = '127.0.0.1'
default['redis']['log_level'] = 'notice'

case node['platform']
when "debian","ubuntu"
  default['redis']['pkg_name'] = 'redis-server'
  default['redis']['pkg_version'] = '2:3.0.6-1'
  default['redis']['dir'] = '/etc/redis'
  default['redis']['logfile'] = '/var/log/redis/redis-server.log'
  default['redis']['pidfile'] = '/var/run/redis/redis-server.pid'
when "redhat","centos"
  default['redis']['pkg_name'] = 'redis'
  default['redis']['pkg_version'] = '3.2.10-2.el7'
  default['redis']['dir'] = '/etc'
  default['redis']['logfile'] = '/var/log/redis/redis.log'
  default['redis']['pidfile'] = '/var/run/redis/redis.pid'
else
  default['redis']['pkg_name'] = 'redis'
  default['redis']['pkg_version'] = nil
  default['redis']['dir'] = '/etc'
  default['redis']['logfile'] = '/var/log/redis/redis.log'
  default['redis']['pidfile'] = '/var/run/redis/redis.pid'
end
