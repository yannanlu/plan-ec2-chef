default['mysql']['port'] = '3306'
default['mysql']['bind_ip'] = '127.0.0.1'
default['mysql']['user'] = 'mysql'
default['mysql']['group'] = 'mysql'
default['mysql']['pidfile'] = '/var/run/mysqld/mysqld.pid'
default['mysql']['root_passwd'] = 'MySQL'
default['mysql']['root_passwd_hash'] = '*1799AB5202FE2E9958365F9B3ECBBF53657254C7'
default['mysql']['db_name'] = 'testdb'
default['mysql']['db_user'] = 'guest'
default['mysql']['db_passwd'] = 'secret'
default['mysql']['db_passwd_hash'] = '*14e65567abdb5135d0cfd9a70b3032c179a49ee7'

case node['platform']
when "debian","ubuntu"
  default['mysql']['dir'] = '/etc/mysql'
  default['mysql']['service_name'] = 'mysql'
  default['mysql']['repo_pkg_name'] = nil
  default['mysql']['pkg_repo_url'] = nil 
  default['mysql']['pkg_name'] = 'mysql-server'
  default['mysql']['pkg_version'] = '5.7.19-0ubuntu0.16.04.1'
  default['mysql']['logfile'] = '/var/log/mysql/mysql.log'
when "redhat","centos"
  default['mysql']['dir'] = '/etc'
  default['mysql']['service_name'] = 'mysqld'
  default['mysql']['repo_pkg_name'] = 'mysql57-community-release-el7-9.noarch.rpm'
  default['mysql']['pkg_repo_url'] = 'https://dev.mysql.com/get'
  default['mysql']['pkg_name'] = 'mysql-community-server'
  default['mysql']['pkg_version'] = '5.7.19-1.el7'
  default['mysql']['logfile'] = '/var/log/mysqld.log'
else
  default['mysql']['dir'] = '/etc'
  default['mysql']['service_name'] = 'mysqld'
  default['mysql']['repo_pkg_name'] = nil
  default['mysql']['pkg_repo_url'] = nil 
  default['mysql']['pkg_name'] = nil
  default['mysql']['pkg_version'] = nil
  default['mysql']['logfile'] = '/var/log/mysqld.log'
end
