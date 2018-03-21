default['influxdb']['user'] = 'influxdb'
default['influxdb']['group'] = 'influxdb'
default['influxdb']['port'] = '8086'
default['influxdb']['bind_ip'] = '127.0.0.1'
default['influxdb']['pkg_name'] = 'influxdb'
default['influxdb']['db_name'] = nil
default['influxdb']['pausetime'] = '5' 
default['influxdb']['dir'] = '/etc/influxdb'
default['influxdb']['logfile'] = '/var/log/influxdb/influxdb.log'
default['influxdb']['pidfile'] = '/var/run/influxdb/influxdb.pid'
default['influxdb']['gpg_key'] = 'https://repos.influxdata.com/influxdb.key'

case node['platform']
when "debian","ubuntu"
  default['influxdb']['repo_uri'] = 'https://repos.influxdata.com/ubuntu' 
  default["influxdb"]["distribution"] = "xenial"
  default["influxdb"]["components"] = ["stable"]
when "redhat","centos"
  default['influxdb']['repo_uri'] = 'https://repos.influxdata.com/rhel/$releasever/$basearch/stable'
  default["influxdb"]["distribution"] = nil
  default["influxdb"]["components"] = nil
end
