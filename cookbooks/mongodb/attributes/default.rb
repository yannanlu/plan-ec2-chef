default["mongodb"]["user"] = "mongod"
default["mongodb"]["group"] = "mongod"
default["mongodb"]["port"] = 27017
default["mongodb"]["bind_ip"] = "127.0.0.1"
default["mongodb"]["dir"] = "/etc"
default["mongodb"]["pkg_name"] = "mongodb-org"
default["mongodb"]["service_name"] = "mongod"
default["mongodb"]["logfile"] = "/var/log/mongodb/mongod.log"

case node["platform"]
when "debian","ubuntu"
  default["mongodb"]["dbpath"] = "/var/lib/mongodb"
  default["mongodb"]["pidfile"] = nil
  default["mongodb"]["repo_uri"] = "http://repo.mongodb.org/apt/ubuntu"
  default["mongodb"]["gpg_key"] = nil
  default["mongodb"]["key_id"] = "EA312927"
  default["mongodb"]["key_server"] = "keyserver.ubuntu.com"
  default["mongodb"]["distribution"] = "xenial/mongodb-org/3.2"
  default["mongodb"]["components"] = ["multiverse"]
when "redhat","centos"
  default["mongodb"]["dbpath"] = "/var/lib/mongo"
  default["mongodb"]["pidfile"] = "/var/run/mongodb/mongod.pid"
  default["mongodb"]["repo_uri"] = "https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/"
  default["mongodb"]["gpg_key"] = "https://www.mongodb.org/static/pgp/server-3.4.asc"
  default["mongodb"]["key_id"] = nil
  default["mongodb"]["key_server"] = nil
  default["mongodb"]["distribution"] = nil
  default["mongodb"]["components"] = nil
else
  default["mongodb"]["dbpath"] = "/var/lib/mongodb"
  default["mongodb"]["pidfile"] = nil
  default["mongodb"]["repo_uri"] = nil
  default["mongodb"]["gpg_key"] = nil
  default["mongodb"]["key_id"] = nil
  default["mongodb"]["key_server"] = nil
  default["mongodb"]["distribution"] = nil
  default["mongodb"]["components"] = nil
end
