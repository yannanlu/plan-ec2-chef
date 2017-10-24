db_type = 'postgresql'
node.override[cookbook_name]['db_type'] = db_type
node.override[db_type]['db_name'] = node[cookbook_name]['db_name']
node.override[db_type]['db_user'] = node[cookbook_name]['db_user'] 
node.override[db_type]['db_passwd'] = node[cookbook_name]['db_passwd']
db_sql_file = node[cookbook_name]['db_sql_file']

include_recipe "#{db_type}::db"

cookbook_file File.join(node[db_type]['homedir'], db_sql_file) do
  source db_sql_file
  owner node[db_type]['user']
  group node[db_type]['group']
  mode '0644'
  notifies :run, "execute[create_tables]", :immediately
end

execute 'create_tables' do
  command "/usr/bin/psql #{node[db_type]['db_name']} -f #{File.join(node[db_type]['homedir'], db_sql_file)}"
  user node[db_type]['user']
  group node[db_type]['group']
  cwd node[db_type]['homedir']
  action :nothing
end

include_recipe "#{cookbook_name}::default"
include_recipe "#{cookbook_name}::nginx"
