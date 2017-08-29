#!/bin/bash

while [ ! -f /opt/chef/embedded/bin/chef-solo ]; do
  echo -e "\033[1;36mWaiting for chef..."
  sleep 5
done

if [ -f /opt/chef/embedded/bin/chef-solo ]; then
  echo -e "\033[1,36mChef is installed"
fi
