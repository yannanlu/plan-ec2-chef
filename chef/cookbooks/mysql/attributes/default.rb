default['mysql']['port'] = '3306'
default['mysql']['bind_ip'] = '127.0.0.1'
default['mysql']['user'] = 'mysql'
default['mysql']['group'] = 'mysql'
default['mysql']['pidfile'] = '/var/run/mysqld/mysqld.pid'
default['mysql']['root_passwd'] = 'MySQL'
default['mysql']['db_name'] = 'testdb'
default['mysql']['db_user'] = 'guest'
default['mysql']['db_passwd'] = 'secret'
default['mysql']['db_sql_file'] = 'create_db.sql'
default['mysql']['wrapper_cookbook'] = nil

case node['platform']
when "debian","ubuntu"
  default['mysql']['dir'] = '/etc/mysql'
  default['mysql']['repo_pkg_name'] = nil
  default['mysql']['pkg_repo_url'] = nil 
when "redhat","centos"
  default['mysql']['dir'] = '/var/lib/mysql'
  default['mysql']['repo_pkg_name'] = 'mysql57-community-release-el7-9.noarch.rpm'
  default['mysql']['pkg_repo_url'] = 'https://dev.mysql.com/get'
else
  default['mysql']['dir'] = '/var/lib/mysql'
  default['mysql']['repo_pkg_name'] = nil
  default['mysql']['pkg_repo_url'] = nil 
end
