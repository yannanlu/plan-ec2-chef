locations = []
locations.push(node['mbservice']['location'])
locations.push(node['activemq']['location'])
node.override['apache']['locations'] = locations

include_recipe "#{cookbook_name}"
include_recipe "apache"
