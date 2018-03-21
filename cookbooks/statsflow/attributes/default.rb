default['statsflow']['db_name'] = 'metricdb'

default['statsflow']['json_files'] = [
  'node_format.json',
  'node_influx_format.json',
  'node_parser.json',
  'node_stats_parser.json',
  'node_switch.json',
  'pstr_failure.json',
  'pstr_influx.json',
  'pstr_nohit.json',
  'pstr_null.json',
  'rcvr_stats_log.json'
]
default['statsflow']['jar_files'] = [
  'commons-io-1.4.jar',
  'commons-net-3.3.jar',
  'jakarta-oro-2.0.8.jar',
  'jms.jar',
  'log4j-1.2.12.jar',
  'qbroker-1.2.1.jar'
]

default['statsflow']['log_location'] = {
  'service' => 'stats',
  'proxy' => 'http://127.0.0.1:8082/logsinc'
}

default['statsflow']['extra_server'] = {
  'port' => '8082',
  'server_name' => 'localhost',
  'docroot' => default['nginx']['default_docroot'] 
}
