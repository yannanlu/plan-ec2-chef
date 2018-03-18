default['eventflow']['es_template'] = 'template_event'

default['eventflow']['json_files'] = [
  "node_parser.json",
  "node_switch.json",
  "node_screen.json",
  "node_data_parser.json",
  "node_format.json",
  "node_correlation.json",
  "node_monitor.json",
  "node_dispatcher.json",
  "node_json_format.json",
  "node_router.json",
  'pstr_elastic.json',
  'pstr_failure.json',
  'pstr_nohit.json',
  'pstr_null.json',
  'pstr_pool.json',
  'rcvr_event_log.json',
  'rule_log_only.json'
]
default['eventflow']['jar_files'] = [
  'activation.jar',
  'commons-io-1.4.jar',
  'commons-net-3.3.jar',
  'jakarta-oro-2.0.8.jar',
  'jms.jar',
  'log4j-1.2.12.jar',
  'mail.jar',
  'qbroker-1.2.1.jar'
]

default['eventflow']['log_location'] = {
  'service' => 'event',
  'proxy' => 'http://127.0.0.1:8082/logsinc'
}

default['eventflow']['extra_server'] = {
  'port' => '8082',
  'server_name' => 'localhost',
  'docroot' => '/var/www/html'
}
