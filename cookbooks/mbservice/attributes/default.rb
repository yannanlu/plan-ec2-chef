default['mbservice']['security_plugin'] = 'qbroker-security-1.0.0.jar'

default['mbservice']['jsp_files'] = [
  'date.jsp',
  'getJSON.jsp',
  'getChildJSON.jsp',
  'toJSON.jsp',
  'toRCJSON.jsp'
]
default['mbservice']['json_files'] = [
  'node_format.json',
  'pstr_failure.json'
]
default['mbservice']['jar_files'] = [
  'activemq-all-5.3.1.jar',
  'commons-fileupload-1.2.2.jar',
  'commons-io-1.4.jar',
  'commons-net-3.3.jar',
  'jakarta-oro-2.0.8.jar',
  'jms.jar',
  'log4j-1.2.12.jar',
  'qbroker-1.2.1.jar'
]

default['mbservice']['location'] = {
  'service' => 'mbservice',
  'proxy' => 'http://127.0.0.1:8080',
  'expire' => 'off'
}
