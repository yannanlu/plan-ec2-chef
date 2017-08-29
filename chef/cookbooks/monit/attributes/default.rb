default['monit']['port']  = '2812'
default['monit']['user']  = 'monit'
default['monit']['passwd']  = 'monit'
default['monit']['pemfile']  = 'monit.pem'

case node['platform']
when "debian","ubuntu"
  default['monit']['dir']  = '/etc/monit'
  default['monit']['includedir']  = '/etc/monit/conf.d'
  default['monit']['idfile']  = '/var/lib/monit/id'
  default['monit']['statefile']  = '/var/lib/monit/state'
when "redhat", "centos" 
  default['monit']['dir']  = '/etc'
  default['monit']['includedir']  = '/etc/monit.d'
  default['monit']['idfile']  = '/var/.monit.id'
  default['monit']['statefile']  = '/var/.monit.state'
else
  default['monit']['dir']  = '/etc/monit'
  default['monit']['includedir']  = '/etc/monit/conf.d'
  default['monit']['idfile']  = '/var/lib/monit/id'
  default['monit']['statefile']  = '/var/lib/monit/state'
end

default['monit']['allow_list'] = [
  '170.140.201.0/24',
  '75.131.197.0/24',
  'localhost'
]
