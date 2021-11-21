#!/bin/bash

# disable selinux or permissive 

selinuxenabled && setenforce 0

cat >/etc/selinux/config<<__EOF
SELINUX=disabled
SELINUXTYPE=targeted
__EOF

sudo -i
yum install nfs-utils -y
mkdir /tmp/nfs_share
mkdir /tmp/nfs_share/upload
systemctl enable nfs-mountd.service
systemctl start nfs-mountd.service

echo "/tmp/nfs_share 192.168.56.11(rw,sync,no_root_squash)" > /etc/exports
exportfs -s
exportfs -a
