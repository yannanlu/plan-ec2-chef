name              "nginx"
maintainer        "Yannan Lu"
maintainer_email  "yannan.lu@yahoo.com"
description       "Installs and configures nginx"
version           "0.1.0"

%w{ ubuntu centos }.each do |os|
  supports os
end

depends           "monit"
