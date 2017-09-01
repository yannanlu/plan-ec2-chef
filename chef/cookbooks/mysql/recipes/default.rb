
case node['platform']
when "debian","ubuntu"
  %w{mysql-server python-mysqldb}.each do |pkg|
    package pkg do
      action :install
    end
  end
when "redhat","centos"
  repo_pkg_name = File.join(Chef::Config[:file_cache_path], node[cookbook_name]['repo_pkg_name']) 
  remote_file repo_pkg_name do
    source "#{node[cookbook_name]['pkg_repo_url']}/#{node[cookbook_name]['repo_pkg_name']}" 
    owner 'root'
    group 'root'
    mode '0644'
  end

  yum_package 'mysql_repo' do
    source repo_pkg_name
    action :install
    flush_cache [:after]
  end

  %w{mysql-server MySQL-python}.each do |pkg|
    package pkg do
      action :install
    end
  end
end

service cookbook_name do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

passwd = node[cookbook_name]['root_passwd']
execute "reset_root_password" do
  command "echo \"update mysql.user set authentication_string=password('#{passwd}'), plugin='mysql_native_password' where user='root' and host='localhost'; flush privileges\" | /usr/bin/mysql"
  user 'root'
  group 'root'
  only_if "echo exit | /usr/bin/mysql"
end

include_recipe "#{cookbook_name}::monit"
