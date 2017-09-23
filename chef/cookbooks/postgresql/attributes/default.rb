default['postgresql']['port'] = '5432'
default['postgresql']['user'] = 'postgres'
default['postgresql']['group'] = 'postgres'
default['postgresql']['dir'] = '/etc/postgresql'
default['postgresql']['db_name'] = 'testdb'
default['postgresql']['db_user'] = 'guest'
default['postgresql']['db_passwd'] = 'secret'
default['postgresql']['db_sql_file'] = 'create_db.sql'
default['postgresql']['wrapper_cookbook'] = nil

case node['platform']
when "debian","ubuntu"
  default['postgresql']['pkg_name'] = 'postgresql'
  default['postgresql']['pkg_version'] = '9.5+173'
  default['postgresql']['homedir'] = '/var/lib/postgresql'
  default['postgresql']['pidfile'] = '/var/run/postgresql/9.5-main.pid'
  default['postgresql']['datadir'] = '/var/lib/postgresql/9.5/main'
  default['postgresql']['cfgdir'] = '/etc/postgresql/9.5/main'
when "redhat","centos"
  default['postgresql']['pkg_name'] = 'postgresql-server'
  default['postgresql']['pkg_version'] = '9.2.23-1.el7_4'
  default['postgresql']['homedir'] = '/var/lib/pgsql'
  default['postgresql']['pidfile'] = '/var/run/postgresql/postgresql.pid'
  default['postgresql']['datadir'] = '/var/lib/pgsql/data'
  default['postgresql']['cfgdir'] = '/var/lib/pgsql/data'
else
  default['postgresql']['pkg_name'] = 'postgresql-server'
  default['postgresql']['pkg_version'] = nil
  default['postgresql']['homedir'] = '/var/lib/pgsql'
  default['postgresql']['pidfile'] = '/var/run/postgresql/postgresql.pid'
  default['postgresql']['datadir'] = '/var/lib/pgsql/data'
  default['postgresql']['cfgdir'] = '/var/lib/pgsql/data'
end
