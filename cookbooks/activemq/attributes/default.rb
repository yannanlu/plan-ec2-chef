
default['activemq']['user'] = 'activemq'
default['activemq']['group'] = 'activemq'
default['activemq']['pidfile'] = '/opt/activemq/data/activemq.pid'
default['activemq']['pkg_name'] = 'apache-activemq'
default['activemq']['version'] = '5.14.3'
default['activemq']['repo_url'] = 'https://archive.apache.org/dist/activemq'

default['activemq']['broker_ip'] = '127.0.0.1'
default['activemq']['broker_port'] = '61616'
default['activemq']['broker_user'] = 'system'
default['activemq']['broker_passwd'] = 'manager'
default['activemq']['guest_passwd'] = 'password'
default['activemq']['jmx'] = 'disabled'
default['activemq']['store_usage'] = '5'
default['activemq']['temp_usage'] = '3'
default['activemq']['pending_limit'] = '1000'
default['activemq']['context_factory'] = 'org.apache.activemq.jndi.ActiveMQInitialContextFactory'
default['activemq']['queue_connection_factory'] = 'QueueConnectionFactory'
default['activemq']['topic_connection_factory'] = 'TopicConnectionFactory'

default['activemq']['admin_ip'] = '127.0.0.1'
default['activemq']['admin_port'] = '8161'
default['activemq']['admin_user'] = 'admin'
default['activemq']['admin_passwd'] = 'admin'
default['activemq']['location'] = {
  'service' => 'admin',
  'proxy' => 'http://127.0.0.1:8161',
  'expire' => 'off'
}
