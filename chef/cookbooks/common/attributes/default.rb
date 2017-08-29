
# Cookbook Name:: common
# Attributes:: default
#

default['common']['sysctl_props']  = [
  'net.ipv4.tcp_tw_reuse',
  'net.ipv4.tcp_tw_recycle',
  'net.ipv6.conf.all.disable_ipv6',
  'net.ipv6.conf.default.disable_ipv6',
  'net.ipv6.conf.lo.disable_ipv6'
]
default['common']['pkg_list']  = [
    'jq',
    'git',
    'lsof',
    'libxml2-utils',
    'expect'
]
