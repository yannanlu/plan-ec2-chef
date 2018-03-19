default['monit']['pkg_name']  = 'monit'
default['monit']['port']  = '2812'
default['monit']['user']  = 'monit'
default['monit']['passwd']  = 'monit'
default['monit']['pemfile']  = 'monit.pem'

case node['platform']
when "debian","ubuntu"
  default['monit']['pkg_version']  = '1:5.16-2'
  default['monit']['dir']  = '/etc/monit'
  default['monit']['includedir']  = '/etc/monit/conf.d'
  default['monit']['idfile']  = '/var/lib/monit/id'
  default['monit']['statefile']  = '/var/lib/monit/state'
  default['monit']['os_release_file']  = '/etc/lsb-release'
when "redhat", "centos" 
  default['monit']['pkg_version']  = '5.14-1.el7'
  default['monit']['dir']  = '/etc'
  default['monit']['includedir']  = '/etc/monit.d'
  default['monit']['idfile']  = '/var/.monit.id'
  default['monit']['statefile']  = '/var/.monit.state'
  default['monit']['os_release_file']  = '/etc/redhat-release'
else
  default['monit']['pkg_version']  = nil
  default['monit']['dir']  = '/etc/monit'
  default['monit']['includedir']  = '/etc/monit/conf.d'
  default['monit']['idfile']  = '/var/lib/monit/id'
  default['monit']['statefile']  = '/var/lib/monit/state'
  default['monit']['os_release_file']  = '/etc/os-release'
end

default['monit']['allow_list'] = [
  '170.140.0.0/16',
  '75.131.197.0/24',
  'localhost'
]
