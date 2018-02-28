default['qbroker']['user'] = 'qbadm'
default['qbroker']['group'] = 'qb'
default['qbroker']['repo_url'] = 's3://ylutest/qbroker'
default['qbroker']['artifact'] = 'qblite-1.0.0.tgz' 
default['qbroker']['basedir'] = '/opt' 
default['qbroker']['logdir'] = '/var/log/qbroker' 
default['qbroker']['javaopts'] = '-server -Dfile.encoding=UTF8 -Xms128m -Xmx512m'
default['qbroker']['service_id'] = 'TEST' 
default['qbroker']['webapp_context'] = nil
default['qbroker']['wrapper_cookbook'] = nil
default['qbroker']['security_plugin'] = nil

default['qbroker']['jsp_files'] = []
default['qbroker']['json_files'] = []
default['qbroker']['jar_files'] = []
