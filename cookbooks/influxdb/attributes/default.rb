default['influxdb']['port'] = '8086'
default['influxdb']['bind_ip'] = '127.0.0.1'
default['influxdb']['pkg_name'] = 'influxdb'
default['influxdb']['dir'] = '/etc/influxdb'
default['influxdb']['logfile'] = '/var/log/influxdb/influxdb.log'
default['influxdb']['pidfile'] = '/var/run/influxdb/influxdb.pid'

case node['platform']
when "debian","ubuntu"
  default['influxdb']['repo_uri'] = nil
  default['influxdb']['gpg_key'] = nil
when "redhat","centos"
  default['influxdb']['repo_uri'] = 'https://repos.influxdata.com/rhel/$releasever/$basearch/stable'
  default['influxdb']['gpg_key'] = 'https://repos.influxdata.com/influxdb.key'
end
