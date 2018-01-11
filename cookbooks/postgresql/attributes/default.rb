default['postgresql']['port'] = '5432'
default['postgresql']['user'] = 'postgres'
default['postgresql']['group'] = 'postgres'
default['postgresql']['db_name'] = 'testdb'
default['postgresql']['db_user'] = 'guest'
default['postgresql']['db_passwd'] = 'secret'

case node['platform']
when "debian","ubuntu"
  default['postgresql']['pkg_name'] = 'postgresql'
  default['postgresql']['pkg_version'] = '9.5+173'
  default['postgresql']['homedir'] = '/var/lib/postgresql'
  default['postgresql']['pidfile'] = '/var/run/postgresql/9.5-main.pid'
  default['postgresql']['datadir'] = '/var/lib/postgresql/9.5/main'
  default['postgresql']['cfgdir'] = '/etc/postgresql/9.5/main'
  default['postgresql']['pattern'] = nil
when "redhat","centos"
  default['postgresql']['pkg_name'] = 'postgresql-server'
  default['postgresql']['pkg_version'] = '9.2.23-1.el7_4'
  default['postgresql']['homedir'] = '/var/lib/pgsql'
  default['postgresql']['pidfile'] = nil
  default['postgresql']['datadir'] = '/var/lib/pgsql/data'
  default['postgresql']['cfgdir'] = '/var/lib/pgsql/data'
  default['postgresql']['pattern'] = '/usr/bin/postgres -D '
else
  default['postgresql']['pkg_name'] = 'postgresql-server'
  default['postgresql']['pkg_version'] = nil
  default['postgresql']['homedir'] = '/var/lib/pgsql'
  default['postgresql']['pidfile'] = '/var/run/postgresql/postgresql.pid'
  default['postgresql']['datadir'] = '/var/lib/pgsql/data'
  default['postgresql']['cfgdir'] = '/var/lib/pgsql/data'
  default['postgresql']['pattern'] = nil
end
