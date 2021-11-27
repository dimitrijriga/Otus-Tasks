#!/bin/bash

# disable selinux or permissive
selinuxenabled && setenforce 0

cat >/etc/selinux/config<<__EOF
SELINUX=disabled
SELINUXTYPE=targeted
__EOF

yum update -y
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc
 
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm

sudo -i
cd /root/
cp /home/vagrant/nginx-1.14.1-1.el7_4.ngx.src.rpm /root/
rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm

yum-builddep -y rpmbuild/SPECS/nginx.spec

wget --no-check-certificate https://www.openssl.org/source/old/1.1.1/openssl-1.1.1k.tar.gz
tar xvf openssl-1.1.1k.tar.gz

sed -i 's/\-\-with\-debug/\-\-with\-openssl\=\/root\/openssl-1.1.1k/g' rpmbuild/SPECS/nginx.spec

rpmbuild -bb rpmbuild/SPECS/nginx.spec
yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm

systemctl start nginx
systemctl status nginx

mkdir /usr/share/nginx/html/repo
cp rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
cd /usr/share/nginx/html/repo/
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/mc-4.8.7-11.el7.x86_64.rpm 
wget http://mirror.ghettoforge.org/distributions/gf/el/7/plus/x86_64/nano-2.7.4-3.gf.el7.x86_64.rpm 

createrepo /usr/share/nginx/html/repo/

cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

yum repolist enabled | grep otus
yum list | grep otus

