locations = []
locations.push(node['idservice']['location'])
node.override['apache']['locations'] = locations

include_recipe "apache"
