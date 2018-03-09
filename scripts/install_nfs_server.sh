#!/usr/bin/env bash

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
