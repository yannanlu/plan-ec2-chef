#
# Cookbook Name:: common
# Recipe:: default
#

pkg_list = node['common']['pkg_list']

pkg_list.each do |pkg|
  package pkg do
    action :install
  end
end
