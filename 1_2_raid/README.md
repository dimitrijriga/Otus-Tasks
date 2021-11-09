# Otus-Tasks	1_2_raid
https://github.com/nixuser/virtlab/blob/main/mdraid/Vagrantfile

Перенос работающей системы с sda на RAID. \
Много времени ушло на Vagrant, чтобы получить конфигурацию для тестов. \
Для создания VM нужно создать /tmp/centos.vmdk \
VBoxManage createhd --filename tmp/centos_40GB.vmdk --size 40960 --format VMDK \
использовать Vagrantfile_move \
результат работы \
[vagrant@centos-7-raid ~]$ lsblk \
NAME    MAJ:MIN RM SIZE RO TYPE  MOUNTPOINT \
sda       8:0    0  40G  0 disk \
└─sda1    8:1    0  40G  0 part \ 
sdb       8:16   0  40G  0 disk \
└─sdb1    8:17   0  40G  0 part \
  └─md0   9:0    0  40G  0 raid1 \


Выполнил много раз, по разным инсрукциям из интернета,
перенос системы выполнялся, но подключиться к OS после переноса я не мог.
Как выяснилось, проблема была в том что был включен SELINUX.\
Список команд для выполнения переноса работающей системы:
sfdisk -d /dev/sda | sfdisk /dev/sdb \
fdisk /dev/sdb \
mdadm --create /dev/md0 --level=1 --raid-devices=2 missing /dev/sdb1 \
mkfs.ext4 /dev/md0 \
mount /dev/md0 /mnt/ \
rsync -axu / /mnt/ \
mount --bind /proc /mnt/proc && mount --bind /dev /mnt/dev && mount --bind /sys /mnt/sys && mount --bind /run /mnt/run && chroot /mnt \
ls -l /dev/disk/by-uuid |grep md >> /etc/fstab && vi /etc/fstab \
mdadm --detail --scan > /etc/mdadm.conf \
mv /boot/initramfs-3.10.0-123.el7.x86_64.img /boot/initramfs-3.10.0-123.el7.x86_64.img.bak \
dracut /boot/initramfs-$(uname -r).img $(uname -r) \
vi /etc/default/grub /// rd.auto=1 \
grub2-mkconfig -o /boot/grub2/grub.cfg && grub2-install /dev/sdb \
cat /boot/grub2/grub.cfg \
sed -i s#SELINUX=enforcing#SELINUX=disabled#  /etc/selinux/config 

Выполняем рестарт, выбираем загрузку с sdb





