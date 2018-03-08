#!/usr/bin/env bash

# Set an initial value

function exportParams() {
    allowed_hosts=`grep 'AllowedHost' ${PARAMS_FILE} | awk -F'|' '{print $2}' | sed -e 's/^ *//g;s/ *$//g'`
    }

if [ $# -ne 1 ]; then
    echo $0: usage: configure_nfs_server.sh "<param-file-path>"
    exit 1
fi

PARAMS_FILE=$1

allowed_hosts='NONE'

#install_magento.sh dbhost dbuser dbpassword dbname cname adminfirstname adminlastname adminemail adminuser adminpassword cachehost magentourl certificateid magentolanguage magentocurrency magentotimezone

if [ -f ${PARAMS_FILE} ]; then
    echo "Extracting parameter values from params file"
    exportParams
else
    echo "Parameters file not found or inaccessible."
    exit 1
fi


# ADD DEFAULT LOCALE
cat << EOF > /etc/environment
LANG=en_US.utf-8
LC_ALL=en_US.utf-8
EOF

# BANNER CONFIGURATION
BANNER_FILE="/etc/ssh_banner"
if [ $BANNER_FILE ] ;then
    echo "[INFO] Installing banner ... "
    echo -e "\nBanner ${BANNER_FILE}" >> /etc/ssh/sshd_config
    service sshd restart
else
    echo "[INFO] banner file is not accessible skipping ..."
    exit 1;
fi

# UPDATE & INSTALL NECESSARY PACKAGES
yum -y update
