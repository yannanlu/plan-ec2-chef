nginx_dir = node['nginx']['dir']

package node[cookbook_name]['pkg_name'] do
  action :install
end

template File.join(nginx_dir, "nginx.conf") do
  owner "root"
  group "root"
  mode 0644
  source "nginx.conf.erb"
  variables(
    :cfgdir => nginx_dir,
    :user => node['nginx']['user'],
    :logdir => node['nginx']['logdir'],
    :pidfile => node['nginx']['pidfile']
  )
  notifies :restart, "service[nginx]"
end

%w{server.crt server.key}.each do |f|
  cookbook_file File.join(nginx_dir, f) do
    source f
    owner 'root'
    group 'root'
    mode '0600'
    notifies :restart, "service[nginx]"
  end
end

template File.join(nginx_dir, 'conf.d', 'default.conf') do
  source 'default.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :cfgdir => nginx_dir,
    :logdir => node['nginx']['logdir'],
    :locations => node['nginx']['locations']
  )
  notifies :restart, "service[nginx]"
end

if node['nginx']['extra_server'].any?
  case node['platform']
  when 'redhat', 'centos'
    port = node['nginx']['extra_server']['port']
    docroot = node['nginx']['extra_server']['docroot']
    execute "seport_http_nginx_#{port}" do
      command "semanage port -m -t http_port_t -p tcp #{port}"
      user 'root'
      group 'root'
      not_if "semanage port -l | grep http | grep #{port}"
    end

    execute "semanage_fcontext_nginx_#{docroot}" do
      command "semanage fconext -a -t httpd_sys_content_t '#{docroot}(/.*?)' && restorecon -R -v #{docroot}"
      user 'root'
      group 'root'
      not_if "semanage fcontext -l | grep httpd_sys_content_t | grep '#{docroot}('"
    end

    directory node[cookbook_name]['logdir'] do
      owner node[cookbook_name]['user']
      group node[cookbook_name]['group']
      mode '0755'
    end
  end

  template File.join(nginx_dir, 'conf.d', 'server.conf') do
    source 'server.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :port => node['nginx']['extra_server']['port'],
      :server_name => node['nginx']['extra_server']['server_name'],
      :docroot => node['nginx']['extra_server']['docroot'],
      :logdir => node['nginx']['logdir'],
      :log_locations => node['nginx']['log_locations']
    )
    notifies :restart, "service[nginx]"
  end
end

service "nginx" do
  supports :status => true, :restart => true
  action [:enable, :nothing]
end

include_recipe "nginx::monit"
