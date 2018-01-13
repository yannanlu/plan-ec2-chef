#!/bin/sh

which apt
if [ $? = 0 ]
then
  sudo apt update -y
  sudo apt install -y python-minimal
else
  which yum
  if [ $? = 0 ]
  then
    sudo yum update -y
    sudo yum install epel-release -y
  fi
fi

curl -LO https://www.opscode.com/chef/install.sh
for retry in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
  if [ -s ./install.sh ]; then
    echo "`date` run install.sh at $retry" >> /tmp/install_chef.log
    sudo bash ./install.sh -v 13.2.20
    if [ -f /opt/chef/embedded/bin/chef-solo ]; then
      echo "`date` ./install.sh completed at $retry" >> /tmp/install_chef.log
      break
    fi
  elif [ -e ./install.sh ]; then
    rm ./install.sh
    echo "`date` empty install.sh at $retry" >> /tmp/install_chef.log
    sleep 10
    curl -LO https://www.opscode.com/chef/install.sh
  fi
done
