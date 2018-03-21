#!/usr/bin/env bash
environment="prod"
application="bastion"
ip_address=`sudo ifconfig | sed -n '2p' | awk '{print $2}' | awk -F ':' '{print $2}' | sed 's/\./-/g'`
host_name="${environment}-${application}-${ip_address}"
sudo hostname $host_name