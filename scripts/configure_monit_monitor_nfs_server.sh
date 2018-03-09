#!/usr/bin/env bash

cp -p /etc/monit.conf /etc/monit.conf.default
cat << EOF > /etc/monit.conf
###############################################################################
## Monit control file
###############################################################################
##
## Comments begin with a '#' and extend through the end of the line. Keywords
## are case insensitive. All path's MUST BE FULLY QUALIFIED, starting with '/'.
##
## Below you will find examples of some frequently used statements. For
## information about the control file and a complete list of statements and
## options, please have a look in the Monit manual.
##
##
###############################################################################
## Global section
###############################################################################
 set httpd port 2812 and
     use address localhost  # only accept connection from localhost
     allow localhost        # allow localhost to connect to the server and
     allow admin:monit      # require user 'admin' with password 'monit'
###############################################################################
## Services
###############################################################################
check process NFS with pidfile /var/run/rpc.statd.pid
        start program = "/etc/init.d/nfs start"
        stop program  = "/etc/init.d/nfs stop"
        if failed host 127.0.0.1 port 2049 type tcp for 2 cycles then restart
        if 2 restarts within 3 cycles then exec "/usr/local/bin/monit_notify_slack"
###############################################################################
## Includes
###############################################################################
##
## It is possible to include additional configuration parts from other files or
## directories.
#
#  include /etc/monit.d/*
#
#

# set daemon mode timeout to 1 minute
set daemon 60
# Include all files from /etc/monit.d/
include /etc/monit.d/*
EOF
monit
monit reload
monit status