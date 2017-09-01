default['idservice']['db_type'] = 'postgresql'
default['idservice']['db_name'] = 'eventdb'
default['idservice']['db_user'] = 'eventdba'
default['idservice']['db_passwd'] = 'secret'
default['idservice']['db_sql_file'] = 'eventid.sql'

default['idservice']['jsp_files'] = [
  'date.jsp',
  'getJSON.jsp',
  'getChildJSON.jsp',
  'toJSON.jsp',
  'toRCJSON.jsp'
]
default['idservice']['json_files'] = [
  'node_format.json',
  'node_cache.json',
  'node_mapreduce.json',
  'node_collect.json',
  'node_jpath.json',
  'node_data_format.json',
  'pstr_null.json',
  'pstr_done_req.json',
  'pstr_failure_req.json',
  'pstr_nohit_req.json',
  'pstr_eval.json',
  'pstr_failure.json',
  'pstr_nohit.json'
]
default['idservice']['jar_files'] = [
  'activation.jar',
  'commons-fileupload-1.2.2.jar',
  'commons-io-1.4.jar',
  'commons-net-3.3.jar',
  'jakarta-oro-2.0.8.jar',
  'jms.jar',
  'log4j-1.2.12.jar',
  'mail.jar',
  'postgresql-9.1-903.jdbc4.jar',
  'qbroker-1.2.0.jar',
  'xercesImpl.jar'
]
