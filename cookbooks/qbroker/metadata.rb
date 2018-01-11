name              "qbroker"
maintainer        "Yannan Lu"
maintainer_email  "yannanlu@yahoo.com"
license           "All rights reserved"
description       "Installs qbroker"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.0"

%w{ ubuntu centos }.each do |os|
  supports os
end
 
depends           "java"
