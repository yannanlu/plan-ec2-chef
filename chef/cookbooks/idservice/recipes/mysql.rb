db_type = 'mysql'
node.override[cookbook_name]['db_type'] = db_type
node.override[db_type]['wrapper_cookbook'] = cookbook_name
node.override[db_type]['db_name'] = node[cookbook_name]['db_name']
node.override[db_type]['db_user'] = node[cookbook_name]['db_user'] 
node.override[db_type]['db_passwd'] = node[cookbook_name]['db_passwd']
db_sql_file = "mysql_#{node[cookbook_name]['db_sql_file']}"

include_recipe "#{db_type}::db"

tmp = Chef::Config[:file_cache_path]
cookbook_file File.join(tmp, db_sql_file) do
  source db_sql_file
  owner 'root'
  group 'root'
  mode '0644'
  notifies :run, "execute[create_tables]", :immediately
end

execute 'create_tables' do
  command "/usr/bin/mysql -u #{node[db_type]['db_user']} -p#{node[db_type]['db_passwd']} #{node[db_type]['db_name']} < #{File.join(tmp, db_sql_file)}"
  user 'root'
  group 'root'
  cwd '/tmp'
  action :nothing
end

include_recipe "#{cookbook_name}::default"
include_recipe "#{cookbook_name}::apache2"
