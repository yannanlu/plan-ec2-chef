default['elasticsearch']['port'] = '9200'
default['elasticsearch']['bind_ip'] = '127.0.0.1'
default['elasticsearch']['pkg_name'] = 'elasticsearch'
default['elasticsearch']['dir'] = '/etc/elasticsearch'
default['elasticsearch']['heapsize'] = '512m'
default['elasticsearch']['logfile'] = '/var/log/elasticsearch/elasticsearch.log'

case node['platform']
when "debian","ubuntu"
  default['elasticsearch']['pidfile'] = '/var/run/elasticsearch.pid'
  default['elasticsearch']['repo_uri'] = nil
  default['elasticsearch']['gpg_key'] = nil
when "redhat","centos"
  default['elasticsearch']['pidfile'] = '/var/run/elasticsearch/elasticsearch.pid'
  default['elasticsearch']['repo_uri'] = 'https://artifacts.elastic.co/packages/6.x/yum'
  default['elasticsearch']['gpg_key'] = 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
end
