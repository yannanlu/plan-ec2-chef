name              "mongodb"
maintainer        "Yannan Lu"
maintainer_email  "yannanlu@yahoo.com"
description       "Installs and configures mongodb"
version           "0.1.0"

recipe "default", "Installs and configures a single node mongodb instance"

%w{ ubuntu debian centos redhat}.each do |os|
  supports os
end

depends "monit"
