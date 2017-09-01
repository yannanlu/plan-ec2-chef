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
  default['postgresql']['homedir'] = '/var/lib/postgresql'
  default['postgresql']['pidfile'] = '/var/run/postgresql/9.5-main.pid'
  default['postgresql']['datadir'] = '/var/lib/postgresql/9.5/main'
  default['postgresql']['cfgdir'] = '/etc/postgresql/9.5/main'
when "redhat","centos"
  default['postgresql']['homedir'] = '/var/lib/pgsql'
  default['postgresql']['pidfile'] = '/var/run/postgresql/postgresql.pid'
  default['postgresql']['datadir'] = '/var/lib/pgsql/data'
  default['postgresql']['cfgdir'] = '/var/lib/pgsql/data'
else
  default['postgresql']['homedir'] = '/var/lib/pgsql'
  default['postgresql']['pidfile'] = '/var/run/postgresql/postgresql.pid'
  default['postgresql']['datadir'] = '/var/lib/pgsql/data'
  default['postgresql']['cfgdir'] = '/var/lib/pgsql/data'
end
