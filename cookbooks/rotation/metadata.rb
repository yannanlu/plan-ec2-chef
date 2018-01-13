name              "rotation"
maintainer        "Yannan Lu"
maintainer_email  "yannan.lu@emory.edu"
license           "All rights reserved"
description       "Installs/Configures a web service"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.0"

%w{ ubuntu centos redhat }.each do |os|
  supports os
end
 
depends           "apache2"
