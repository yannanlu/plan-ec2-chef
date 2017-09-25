
root_passwd = node[cookbook_name]['root_passwd']

case node['platform']
when "debian","ubuntu"
  apt_package node[cookbook_name]['pkg_name'] do
    action :install
  end

  apt_package 'python-mysqldb' do
    action :install
  end

  service cookbook_name do
    service_name node[cookbook_name]['service_name']
    supports :status => true, :restart => true
    action [ :enable, :start ]
  end

  execute "reset_root_password" do
    command "echo \"update mysql.user set authentication_string=password('#{root_passwd}'), plugin='mysql_native_password' where user='root' and host='localhost'; flush privileges\" | /usr/bin/mysql"
    user 'root'
    group 'root'
    only_if "echo exit | /usr/bin/mysql"
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

  yum_package node[cookbook_name]['pkg_name'] do
    action :install
  end

  yum_package 'MySQL-python' do
    action :install
  end

  service cookbook_name do
    service_name node[cookbook_name]['service_name']
    supports :status => true, :restart => true
    action [ :enable, :start ]
  end

  execute "pause" do
    command "sleep 10"
  end

  ruby_block "grep_tmp_passwd" do
    action :create
    block do
        Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)      
        command = "grep 'temporary password' #{node[cookbook_name]['logfile']}"
        command_out = shell_out(command)
        s = "#{command_out.stdout}"
        node.normal['mysql_tmp_passwd'] = s.split(' ')[-1]
        not_if "echo exit | /usr/bin/mysql -u root -p'#{root_passwd}'"
    end
  end

  root_passwd_hash = node[cookbook_name]['root_passwd_hash']
  execute "reset_root_password" do
    command lazy { "echo \"alter user 'root'@'localhost' identified with mysql_native_password as '#{root_passwd_hash}'\" | /usr/bin/mysql --connect-expired-password -u root -p'#{node['mysql_tmp_passwd']}'" }
    user 'root'
    group 'root'
    not_if "echo exit | /usr/bin/mysql -u root -p'#{root_passwd}'"
  end
end

include_recipe "#{cookbook_name}::monit"
