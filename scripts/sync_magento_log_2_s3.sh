#!/usr/bin/env bash
# Variables #
s3_bucket="precita-log"
environment="stage"
ip_address=`sudo ifconfig | sed -n '2p' | awk '{print $2}' | awk -F ':' '{print $2}' | sed 's/\./-/g'`
application="magento"
s3_uri="s3://${s3_bucket}/${environment}/${application}/${ip_address}/"
local_path="/var/www/html/var/log/"

# Execute #
#echo $local_path
#echo $s3_uri
/usr/bin/aws s3 sync --exclude "MailChimp.log" $local_path $s3_uri --dryrun