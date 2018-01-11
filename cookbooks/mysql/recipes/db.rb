include_recipe "#{cookbook_name}"

tmp = Chef::Config[:file_cache_path]
root_passwd = node[cookbook_name]['root_passwd']
db_name = node[cookbook_name]['db_name']
db_user = node[cookbook_name]['db_user']
db_passwd = node[cookbook_name]['db_passwd']

case node['platform']
when "redhat","centos"
  db_passwd_hash = node[cookbook_name]['db_passwd_hash']
else
  db_passwd_hash = nil
end

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
  notifies :run, "execute[mysql_create_db]", :immediately
end

execute 'mysql_create_db' do
  command "/usr/bin/mysql -u root -p'#{root_passwd}' < #{File.join(tmp, 'create_db.sql')}"
  user 'root'
  group 'root'
  cwd '/tmp'
  action :nothing
end
