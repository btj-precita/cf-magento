#!/usr/bin/env bash

rundate=`date +%Y%m%d%H%M`
#nfs_server_host=$1

# Backup
/var/www/html/bin/magento maintenance:enable
mkdir -p ~/backup/media/
mv /var/www/html/pub/media ~/backup/media/media.configure_nfs.${rundate}

# Mount NFS Folder
mkdir -p /var/www/html/pub/media
chown -R ec2-user:nginx /var/www/html/pub/media
sudo mount ${nfs_server_host}:/precita/media /var/www/html/pub/media/
# Sync current media
cd /var/www/html/pub/media/
rsync -av ~/backup/media/media.configure_nfs.${rundate}/* .
sudo service php-fpm restart
/var/www/html/bin/magento maintenance:disable
# Mount at boot
echo "${nfs_server_host}:/precita/media  /var/www/html/pub/media   nfs      auto,noatime,nolock,bg,intr,tcp,actimeo=1800 0 0" | sudo tee -a /etc/fstab
