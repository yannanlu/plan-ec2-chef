default['qbroker']['user'] = 'qbadm'
default['qbroker']['group'] = 'qb'
default['qbroker']['dir'] = '/opt/qbroker'
default['qbroker']['repo_url'] = 's3://ylutest/qbroker'
default['qbroker']['artifact'] = 'qblite-1.0.0.tgz'
default['qbroker']['logdir'] = '/var/log/qbroker'
default['qbroker']['java_opts'] = '-server -Dfile.encoding=UTF8 -Xmx256M'
default['qbroker']['service_id'] = 'TEST'
default['qbroker']['webapp_context'] = nil
default['qbroker']['wrapper_cookbook'] = nil
default['qbroker']['security_plugin'] = nil
default['qbroker']['aws_region'] = 'us-east-2'

default['qbroker']['jar_files'] = []
default['qbroker']['json_files'] = []
default['qbroker']['jsp_files'] = []
