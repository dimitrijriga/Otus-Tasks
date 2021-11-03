# Otus-Tasks	1_1_kernel
vagrant up
vagrant ssh
sudo yum install -y http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
sudo yum --enablerepo elrepo-kernel install kernel-ml -y
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo grub2-set-default 0
sudo reboot
uname -r

# Documents/OTUS-Linux/manual_kernel_update/packer/centos.json
nano centos.json

"artifact_description": "CentOS 7.7 with kernel 5.x",

"artifact_version": "7.7.1908",


"iso_url": "http://mirror.yandex.ru/centos/7.7.1908/isos/x86_64/CentOS-7-x86_64-Minimal-1908.iso",

"iso_checksum": "9a2c47d97b9975452f7d582264e9fc16d108ed8252ac6816239a3b58cef5c53d",

"iso_checksum_type": "sha256",

"output": "centos-{{user `artifact_version`}}-kernel-5-x86_64-Minimal.box",

"scripts" : 

  [

   "scripts/stage-1-kernel-update.sh",

   "scripts/stage-2-clean.sh"

  ]


packer fix centos.json > centos_1.json

packer build centos_1.json

vagrant box add --name centos-7-5 centos-7.7.1908-kernel-5-x86_64-Minimal.box

###

vagrant cloud auth login

Vagrant Cloud username or email: <user_email>

Password (will be hidden): 

Token description (Defaults to "Vagrant login from DS-WS"):

You are now logged in.

###

vagrant cloud publish --release dimitrijriga/centos-7-5 1.0 virtualbox centos-7.7.1908-kernel-5-x86_64-Minimal.box

