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

curl -LO https://www.opscode.com/chef/install.sh && sudo bash ./install.sh -v 13.2.20
