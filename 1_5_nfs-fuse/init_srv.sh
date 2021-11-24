#!/bin/bash

# disable selinux or permissive 

selinuxenabled && setenforce 0

cat >/etc/selinux/config<<__EOF
SELINUX=disabled
SELINUXTYPE=targeted
__EOF

sudo -i
systemctl start firewalld
firewall-cmd --permanent --add-service=nfs --zone=public
firewall-cmd --permanent --add-service=rpc-bind --zone=public
firewall-cmd --permanent --add-service=mountd --zone=public
firewall-cmd --reload

yum install nfs-utils -y
yum install -y net-tools

mkdir /tmp/nfs_share
mkdir /tmp/nfs_share/upload

echo "/tmp/nfs_share 192.168.56.11(rw,sync,no_root_squash)" > /etc/exports
sed -i 's/\# vers3=n/vers3=y/g' /etc/nfs.conf
sed -i 's/\# vers4=y/vers4=n/g' /etc/nfs.conf
sed -i 's/\# vers4.0=y/vers4.0=n/g' /etc/nfs.conf
sed -i 's/\# vers4.1=y/vers4.1=n/g' /etc/nfs.conf
sed -i 's/\# vers4.2=y/vers4.2=n/g' /etc/nfs.conf
sed -i 's/\# tcp=y/udp=y/g' /etc/nfs.conf

systemctl enable nfs-mountd.service
systemctl start nfs-mountd.service

exportfs -s
exportfs -a
