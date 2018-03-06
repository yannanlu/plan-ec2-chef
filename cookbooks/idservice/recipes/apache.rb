locations = []
locations.push(node['idservice']['location'])
node.override['apache2']['locations'] = locations

include_recipe "apache2"
