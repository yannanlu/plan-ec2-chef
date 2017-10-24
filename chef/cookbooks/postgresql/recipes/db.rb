include_recipe "#{cookbook_name}"

template File.join(node[cookbook_name]['homedir'], 'create_db.sql') do
  source 'create_db.sql.erb'
  owner node[cookbook_name]['user']
  group node[cookbook_name]['group']
  mode '0644'
  variables(
    :db_name => node[cookbook_name]['db_name'],
    :db_user => node[cookbook_name]['db_user'],
    :db_passwd => node[cookbook_name]['db_passwd'] 
  )
  notifies :run, "execute[create_db]", :immediately
end

execute 'create_db' do
  command "/usr/bin/psql -f #{File.join(node[cookbook_name]['homedir'], 'create_db.sql')}"
  user node[cookbook_name]['user']
  group node[cookbook_name]['group']
  cwd node[cookbook_name]['homedir']
  action :nothing
end
