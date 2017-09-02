include_recipe "#{cookbook_name}"

tmp = Chef::Config[:file_cache_path]
root_passwd = node[cookbook_name]['root_passwd']
db_name = node[cookbook_name]['db_name']
db_user = node[cookbook_name]['db_user']
db_passwd = node[cookbook_name]['db_passwd']
db_passwd_hash = node[cookbook_name]['db_passwd_hash']

template File.join(tmp, 'create_db.sql') do
  source 'create_db.sql.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :db_name => db_name,
    :db_user => db_user,
    :db_passwd => db_passwd,
    :db_passwd_hash => db_passwd_hash
  )
  notifies :run, "execute[create_db]", :immediately
end

execute 'create_db' do
  command "/usr/bin/mysql -u root -p#{root_passwd} < #{File.join(tmp, 'create_db.sql')}"
  user 'root'
  group 'root'
  cwd '/tmp'
  action :nothing
end

if node[cookbook_name]['wrapper_cookbook'] != nil
  cookbook_file File.join(tmp, node[cookbook_name]['db_sql_file']) do
    cookbook node[cookbook_name]['wrapper_cookbook']
    source node[cookbook_name]['db_sql_file']
    owner 'root'
    group 'root'
    mode '0644'
    notifies :run, "execute[create_tables]", :immediately
  end
end

execute 'create_tables' do
  command "/usr/bin/mysql -u #{db_user} -p#{db_passwd} #{db_name} < #{File.join(tmp, node[cookbook_name]['db_sql_file'])}"
  user 'root'
  group 'root'
  cwd '/tmp'
  action :nothing
end
