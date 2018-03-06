locations = []
locations.push(node['idservice']['location'])
node.override['nginx']['locations'] = locations

include_recipe "nginx"
