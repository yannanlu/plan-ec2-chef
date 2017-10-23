db_type = 'postgresql'
node.override[cookbook_name]['db_type'] = db_type
node.override[db_type]['wrapper_cookbook'] = cookbook_name
node.override[db_type]['db_name'] = node[cookbook_name]['db_name']
node.override[db_type]['db_user'] = node[cookbook_name]['db_user'] 
node.override[db_type]['db_passwd'] = node[cookbook_name]['db_passwd']
node.override[db_type]['db_sql_file'] = node[cookbook_name]['db_sql_file']

include_recipe "#{db_type}::db"
include_recipe "#{cookbook_name}::default"
include_recipe "#{cookbook_name}::nginx"
