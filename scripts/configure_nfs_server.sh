#!/usr/bin/env bash

echo "parameters: ${allowed_hosts}"
# CONFIGURE NFS SERVER #
# FORMAT SHARED PARTITION
FORMAT_SHARED_DISK_FILE="/tmp/format_shared_disk.sh"
if [ FORMAT_SHARED_DISK_FILE ] ;then
    echo "[INFO] Formatting shared disk ... "
    /tmp/format_shared_disk.sh
else
    echo "[INFO] format_shared_disk file is not accessible skipping ..."
    exit 1;
fi

# CONFIGURE SHARED DIRECTORY
mkdir -p /precita
mount /dev/xvdh1 /precita/
mkdir -p /precita/media
adduser nginx
chown -R ec2-user:nginx /precita/media
cat << EOF > /etc/exports
/precita/media  ${allowed_hosts}(rw,sync,no_root_squash,no_subtree_check)
EOF
exportfs -a

# MONITOR NFS SERVER WITH MONIT #
CONFIGURE_MONIT_FILE="/tmp/configure_monit_monitor_nfs_server.sh"
if [ CONFIGURE_MONIT_FILE ] ;then
    echo "[INFO] Configure monitoring NFS Server with Monit ... "
    /tmp/configure_monit_monitor_nfs_server.sh
else
    echo "[INFO] configure_monit_monitor_nfs_server file is not accessible skipping ..."
    exit 1;
fi