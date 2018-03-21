
# Cookbook Name:: common
# Attributes:: default
#

default['common']['swap_size'] = '0'
default['common']['sysctl_props']  = [
  'net.ipv4.tcp_tw_reuse = 1',
  'net.ipv4.tcp_tw_recycle = 1',
  'net.ipv6.conf.all.disable_ipv6 = 1',
  'net.ipv6.conf.default.disable_ipv6 = 1',
  'net.ipv6.conf.lo.disable_ipv6 = 1'
]
default['common']['pkg_list']  = [
    'jq',
    'git',
    'lsof',
    'expect',
    'python-pip'
]
