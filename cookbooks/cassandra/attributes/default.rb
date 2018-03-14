default["cassandra"]["user"] = "cassandra"
default["cassandra"]["group"] = "cassandra"
default["cassandra"]["port"] = 9042
default["cassandra"]["bind_ip"] = "127.0.0.1"
default["cassandra"]["heapsize"] = "400M"
default["cassandra"]["pkg_name"] = "cassandra"
default["cassandra"]["logfile"] = "/var/log/cassandra/cassandra.log"
default["cassandra"]["pidfile"] = "/var/run/cassandra/cassandra.pid"

case node["platform"]
when "debian","ubuntu"
  default["cassandra"]["dir"] = "/etc/cassandra"
  default["cassandra"]["repo_uri"] = "http://www.apache.org/dist/cassandra/debian"
  default["cassandra"]["gpg_key"] = "https://www.apache.org/dist/cassandra/KEYS"
  default["cassandra"]["key_id"] = "A278B781FE4B2BDA"
  default["cassandra"]["key_server"] = "pool.sks-keyservers.net"
  default["cassandra"]["distribution"] = "311x"
  default["cassandra"]["components"] = ["main"]
when "redhat","centos"
  default["cassandra"]["dir"] = "/etc/cassandra/default.conf"
  default["cassandra"]["repo_uri"] = "https://www.apache.org/dist/cassandra/redhat/311x/"
  default["cassandra"]["gpg_key"] = "https://www.apache.org/dist/cassandra/KEYS"
  default["cassandra"]["key_id"] = nil
  default["cassandra"]["key_server"] = nil
  default["cassandra"]["distribution"] = nil
  default["cassandra"]["components"] = nil
else
  default["cassandra"]["dir"] = "/etc/cassandra"
  default["cassandra"]["repo_uri"] = nil
  default["cassandra"]["gpg_key"] = nil
  default["cassandra"]["key_id"] = nil
  default["cassandra"]["key_server"] = nil
  default["cassandra"]["distribution"] = nil
  default["cassandra"]["components"] = nil
end
