default['elasticsearch']['port'] = '9200'
default['elasticsearch']['bind_ip'] = '127.0.0.1'
default['elasticsearch']['pkg_name'] = 'elasticsearch'
default['elasticsearch']['dir'] = '/etc/elasticsearch'
default['elasticsearch']['pausetime'] = '15'
default['elasticsearch']['heapsize'] = '512m'
default['elasticsearch']['logfile'] = '/var/log/elasticsearch/elasticsearch.log'
default['elasticsearch']['pidfile'] = '/var/run/elasticsearch/elasticsearch.pid'
default['elasticsearch']['gpg_key'] = 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'

case node['platform']
when "debian","ubuntu"
  default['elasticsearch']['repo_uri'] = 'https://artifacts.elastic.co/packages/5.x/apt'
  default['elasticsearch']['distribution'] = 'stable'
  default['elasticsearch']['components'] = ['main']
when "redhat","centos"
  default['elasticsearch']['repo_uri'] = 'https://artifacts.elastic.co/packages/5.x/yum'
  default['elasticsearch']['distribution'] = nil
  default['elasticsearch']['components'] = nil
end

default['elasticsearch']['index_template'] = {}
