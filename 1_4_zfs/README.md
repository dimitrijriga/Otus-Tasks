modprobe zfs \
yum install -y wget

[root@client ~]# lsblk \
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT \
sda      8:0    0  10G  0 disk \
└─sda1   8:1    0  10G  0 part / \
sdb      8:16   0   1G  0 disk \
sdc      8:32   0   1G  0 disk \
sdd      8:48   0   1G  0 disk \
[root@client ~]# zpool create pool0 raidz1 /dev/sd[b-d] \
[root@client ~]# zfs create pool0/data1 \
[root@client ~]# zfs create pool0/data2 \
[root@client ~]# zfs create pool0/data3 \
[root@client ~]# zfs create pool0/data4 \
[root@client ~]# zpool list \
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT \
pool0  2.75G   584K  2.75G        -         -     0%     0%  1.00x    ONLINE  - \
[root@client ~]# zfs get mounted \
NAME         PROPERTY  VALUE    SOURCE \
pool0        mounted   yes      - \
pool0/data1  mounted   yes      - \
pool0/data2  mounted   yes      - \
pool0/data3  mounted   yes      - \
pool0/data4  mounted   yes      - \
[root@client ~]# \
[root@client ~]# zpool status \
  pool: pool0 \
 state: ONLINE \
config: 

        NAME        STATE     READ WRITE CKSUM \
        pool0       ONLINE       0     0     0 \
          raidz1-0  ONLINE       0     0     0 \
            sdb     ONLINE       0     0     0 \
            sdc     ONLINE       0     0     0 \
            sdd     ONLINE       0     0     0 

errors: No known data errors \
[root@client ~]# \
[root@client ~]# zfs set compression=lzjb pool0/data1 \
[root@client ~]# zfs set compression=lz4 pool0/data2 \
[root@client ~]# zfs set compression=gzip-1 pool0/data3 \
[root@client ~]# zfs set compression=gzip-9 pool0/data4 \
[root@client ~]# \
[root@client ~]# zfs set quota=450M pool0/data1 \
[root@client ~]# zfs set quota=500M pool0/data2 \
[root@client ~]# zfs set quota=550M pool0/data3 \
[root@client ~]# zfs set quota=600M pool0/data4 \
[root@client ~]# \
[root@client ~]# zfs set compression=on pool0 \
[root@client ~]# \
[root@client ~]# zfs get compression,compressratio \
NAME         PROPERTY       VALUE           SOURCE \
pool0        compression    on              local \
pool0        compressratio  1.00x           - \
pool0/data1  compression    lzjb            local \
pool0/data1  compressratio  1.00x           - \
pool0/data2  compression    lz4             local \
pool0/data2  compressratio  1.00x           - \
pool0/data3  compression    gzip-1          local \
pool0/data3  compressratio  1.00x           - \
pool0/data4  compression    gzip-9          local \
pool0/data4  compressratio  1.00x           - \
[root@client ~]# \
[root@client ~]# df -h \
Filesystem      Size  Used Avail Use% Mounted on \
devtmpfs        467M     0  467M   0% /dev \
tmpfs           485M     0  485M   0% /dev/shm \
tmpfs           485M   13M  473M   3% /run \
tmpfs           485M     0  485M   0% /sys/fs/cgroup \
/dev/sda1        10G  3.4G  6.6G  34% / \
tmpfs            97M     0   97M   0% /run/user/1000 \
pool0           1.8G  128K  1.8G   1% /pool0 \
pool0/data1     450M  128K  450M   1% /pool0/data1 \
pool0/data2     500M  128K  500M   1% /pool0/data2 \
pool0/data3     550M  128K  550M   1% /pool0/data3 \
pool0/data4     600M  128K  600M   1% /pool0/data4 \
[root@client ~]# \
[root@client ~]# lsblk \
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT \
sda      8:0    0   10G  0 disk \
└─sda1   8:1    0   10G  0 part / \
sdb      8:16   0    1G  0 disk \
├─sdb1   8:17   0 1014M  0 part \
└─sdb9   8:25   0    8M  0 part \
sdc      8:32   0    1G  0 disk \
├─sdc1   8:33   0 1014M  0 part \
└─sdc9   8:41   0    8M  0 part \
sdd      8:48   0    1G  0 disk \
├─sdd1   8:49   0 1014M  0 part \
└─sdd9   8:57   0    8M  0 part \
[root@client ~]# \
[root@client ~]# cd /pool0/data1 \
[root@client data1]# wget http://tolstoy.ru/upload/iblock/b22/voina-i-mir.docx \
[root@client data1]# wget https://all-the-books.ru/download_book/voyna-i-mir-tom-1.txt \
[root@client data1]# zfs list \
NAME          USED  AVAIL     REFER  MOUNTPOINT \
pool0        4.12M  1.70G     36.0K  /pool0 \
pool0/data1  3.88M   446M     3.88M  /pool0/data1 \
pool0/data2  30.6K   500M     30.6K  /pool0/data2 \
pool0/data3  30.6K   550M     30.6K  /pool0/data3 \
pool0/data4  30.6K   600M     30.6K  /pool0/data4 \
[root@client data1]# cd /pool0/data2 \
[root@client data2]# wget http://tolstoy.ru/upload/iblock/b22/voina-i-mir.docx \
[root@client data2]# wget https://all-the-books.ru/download_book/voyna-i-mir-tom-1.txt \
[root@client data2]# cd /pool0/data3 \
[root@client data3]# wget http://tolstoy.ru/upload/iblock/b22/voina-i-mir.docx \
[root@client data3]# wget https://all-the-books.ru/download_book/voyna-i-mir-tom-1.txt \
[root@client data3]# cd /pool0/data4 \
[root@client data4]# wget http://tolstoy.ru/upload/iblock/b22/voina-i-mir.docx \
[root@client data4]# wget https://all-the-books.ru/download_book/voyna-i-mir-tom-1.txt \
[root@client data4]# zfs list \
NAME          USED  AVAIL     REFER  MOUNTPOINT \
pool0        15.6M  1.69G     36.0K  /pool0 \
pool0/data1  3.88M   446M     3.88M  /pool0/data1 \
pool0/data2  3.87M   496M     3.87M  /pool0/data2 \
pool0/data3  3.86M   546M     3.86M  /pool0/data3 \
pool0/data4  3.86M   596M     3.86M  /pool0/data4 \
[root@client data4]# zfs get compression,compressratio \
NAME         PROPERTY       VALUE           SOURCE \
pool0        compression    on              local \
pool0        compressratio  1.01x           - \
pool0/data1  compression    lzjb            local \
pool0/data1  compressratio  1.00x           - \
pool0/data2  compression    lz4             local \
pool0/data2  compressratio  1.01x           - \
pool0/data3  compression    gzip-1          local \
pool0/data3  compressratio  1.01x           - \
pool0/data4  compression    gzip-9          local \
pool0/data4  compressratio  1.01x           - \
[root@client data4]#  \
[root@client vagrant]# chown -R vagrant.vagrant zpoolexport/ \
[root@client zpoolexport]# zpool import -d filea \
   pool: otus \
     id: 6554193320433390805 \
  state: DEGRADED \
status: One or more devices are missing from the system. \
 action: The pool can be imported despite missing or damaged devices.  The \
        fault tolerance of the pool may be compromised if imported. \
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-2Q \
 config: 

        otus                            DEGRADED \
          mirror-0                      DEGRADED \
            /vagrant/zpoolexport/filea  ONLINE \
            /root/zpoolexport/fileb     UNAVAIL  cannot open \
[root@client zpoolexport]# \
[root@client zpoolexport]# zpool import -d fileb \
   pool: otus \
     id: 6554193320433390805 \
  state: DEGRADED \
status: One or more devices are missing from the system. \
 action: The pool can be imported despite missing or damaged devices.  The \
        fault tolerance of the pool may be compromised if imported. \
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-2Q \
 config: 

        otus                            DEGRADED \
          mirror-0                      DEGRADED \
            /root/zpoolexport/filea     UNAVAIL  cannot open \
            /vagrant/zpoolexport/fileb  ONLINE \
[root@client zpoolexport]# \
[root@client vagrant]# zpool import -a -d zpoolexport/filea \
[root@client vagrant]# zpool list \
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT \
otus    480M  2.10M   478M        -         -     0%     0%  1.00x  DEGRADED  - \
pool0  2.75G  41.4M  2.71G        -         -     0%     1%  1.00x    ONLINE  - \
[root@client vagrant]# \
[root@client vagrant]# zfs list \
NAME             USED  AVAIL     REFER  MOUNTPOINT \
otus            2.04M   350M       24K  /otus \
otus/hometask2  1.88M   350M     1.88M  /otus/hometask2 \
pool0           27.6M  1.68G     36.0K  /pool0 \
pool0/data1     3.88M   446M     3.88M  /pool0/data1 \
pool0/data2     3.87M   496M     3.87M  /pool0/data2 \
pool0/data3     3.86M   546M     3.86M  /pool0/data3 \
pool0/data4     15.8M   584M     15.8M  /pool0/data4 \
[root@client vagrant]# \
[root@client vagrant]# zfs get compression,compressratio \
NAME            PROPERTY       VALUE           SOURCE \
otus            compression    zle             local \
otus            compressratio  1.00x           - \
otus/hometask2  compression    zle             inherited from otus \
otus/hometask2  compressratio  1.00x           - \
pool0           compression    on              local \
pool0           compressratio  1.08x           - \
pool0/data1     compression    lzjb            local \
pool0/data1     compressratio  1.00x           - \
pool0/data2     compression    lz4             local \
pool0/data2     compressratio  1.01x           - \
pool0/data3     compression    gzip-1          local \
pool0/data3     compressratio  1.01x           - \
pool0/data4     compression    gzip-9          local \
pool0/data4     compressratio  1.13x           - \
[root@client vagrant]# \
[root@client vagrant]# zpool status \
  pool: otus \
 state: DEGRADED \
status: One or more devices could not be opened.  Sufficient replicas exist for \
        the pool to continue functioning in a degraded state. \
action: Attach the missing device and online it using 'zpool online'. \
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-2Q \
config: 

        NAME                            STATE     READ WRITE CKSUM \
        otus                            DEGRADED     0     0     0 \
          mirror-0                      DEGRADED     0     0     0 \
            /vagrant/zpoolexport/filea  ONLINE       0     0     0 \
            12715741920600713412        UNAVAIL      0     0     0  was /root/zpoolexport/fileb 

errors: No known data errors \
[root@client vagrant]# zfs get checksum otus \
NAME  PROPERTY  VALUE      SOURCE \
otus  checksum  sha256     local \
[root@client vagrant]# \
[root@client vagrant]# zfs get all otus \
NAME  PROPERTY              VALUE                  SOURCE \
otus  type                  filesystem             - \
otus  creation              Fri May 15  4:00 2020  - \
otus  used                  2.04M                  - \
otus  available             350M                   - \
otus  referenced            24K                    - \
otus  compressratio         1.00x                  - \
otus  mounted               yes                    - \
otus  quota                 none                   default \
otus  reservation           none                   default \
otus  recordsize            128K                   local \
otus  mountpoint            /otus                  default \
otus  sharenfs              off                    default \
otus  checksum              sha256                 local \
otus  compression           zle                    local \
otus  atime                 on                     default \
otus  devices               on                     default \
otus  exec                  on                     default \
otus  setuid                on                     default \
otus  readonly              off                    default \
otus  zoned                 off                    default \
otus  snapdir               hidden                 default \
otus  aclmode               discard                default \
otus  aclinherit            restricted             default \
otus  createtxg             1                      - \
otus  canmount              on                     default \
otus  xattr                 on                     default \
otus  copies                1                      default \
otus  version               5                      - \
otus  utf8only              off                    - \
otus  normalization         none                   - \
otus  casesensitivity       sensitive              - \
otus  vscan                 off                    default \
otus  nbmand                off                    default \
otus  sharesmb              off                    default \
otus  refquota              none                   default \
otus  refreservation        none                   default \
otus  guid                  14592242904030363272   - \
otus  primarycache          all                    default \
otus  secondarycache        all                    default \
otus  usedbysnapshots       0B                     - \
otus  usedbydataset         24K                    - \
otus  usedbychildren        2.01M                  - \
otus  usedbyrefreservation  0B                     - \
otus  logbias               latency                default \
otus  objsetid              54                     - \
otus  dedup                 off                    default \
otus  mlslabel              none                   default \
otus  sync                  standard               default \
otus  dnodesize             legacy                 default \
otus  refcompressratio      1.00x                  - \
otus  written               24K                    - \
otus  logicalused           1020K                  - \
otus  logicalreferenced     12K                    - \
otus  volmode               default                default \
otus  filesystem_limit      none                   default \
otus  snapshot_limit        none                   default \
otus  filesystem_count      none                   default \
otus  snapshot_count        none                   default \
otus  snapdev               hidden                 default \
otus  acltype               off                    default \
otus  context               none                   default \
otus  fscontext             none                   default \
otus  defcontext            none                   default \
otus  rootcontext           none                   default \
otus  relatime              off                    default \
otus  redundant_metadata    all                    default \
otus  overlay               on                     default \
otus  encryption            off                    default \
otus  keylocation           none                   default \
otus  keyformat             none                   default \
otus  pbkdf2iters           0                      default \
otus  special_small_blocks  0                      default \
[root@client vagrant]# \
[root@client vagrant]# df -h \
Filesystem      Size  Used Avail Use% Mounted on \
devtmpfs        468M     0  468M   0% /dev \
tmpfs           485M     0  485M   0% /dev/shm \
tmpfs           485M  6.5M  479M   2% /run \
tmpfs           485M     0  485M   0% /sys/fs/cgroup \
/dev/sda1        10G  4.5G  5.6G  45% / \
pool0           1.7G  128K  1.7G   1% /pool0 \
pool0/data1     450M  4.0M  446M   1% /pool0/data1 \
pool0/data4     600M   16M  585M   3% /pool0/data4 \
pool0/data2     500M  3.9M  497M   1% /pool0/data2 \
pool0/data3     550M  3.9M  547M   1% /pool0/data3 \
tmpfs            97M     0   97M   0% /run/user/1000 \
otus            350M  128K  350M   1% /otus \
otus/hometask2  352M  2.0M  350M   1% /otus/hometask2 \
[root@client vagrant]# 
********************************************************** \
[root@server pool0]# rm -rfv /pool0/data1/*  \
[root@server pool0]# rm -rfv /pool0/data2/* \
[root@server pool0]# rm -rfv /pool0/data3/* \
[root@server pool0]# rm -rfv /pool0/data4/* 

[root@server pool0]# zfs receive pool0/otus_task2 < /vagrant/otus_task2.file  \
[root@server pool0]# ls -la /pool0/otus_task2/ \
total 2109 \
drwxr-xr-x. 3 root    root         11 May 15  2020 . \
drwxr-xr-x. 7 root    root          7 Nov 29 19:37 .. \
-rw-r--r--. 1 root    root          0 May 15  2020 10M.file \
-rw-r--r--. 1 root    root     727040 May 15  2020 cinderella.tar \
-rw-r--r--. 1 root    root         65 May 15  2020 for_examaple.txt \
-rw-r--r--. 1 root    root          0 May 15  2020 homework4.txt \
-rw-r--r--. 1 root    root     309987 May 15  2020 Limbo.txt \
-rw-r--r--. 1 root    root     509836 May 15  2020 Moby_Dick.txt \
drwxr-xr-x. 3 vagrant vagrant       4 Dec 18  2017 task1 \
-rw-r--r--. 1 root    root    1209374 May  6  2016 War_and_Peace.txt \
-rw-r--r--. 1 root    root     398635 May 15  2020 world.sql \
[root@server pool0]# find /pool0/otus_task2/ -name secret_message \
/pool0/otus_task2/task1/file_mess/secret_message \
[root@server pool0]# cat /pool0/otus_task2/task1/file_mess/secret_message \
https://github.com/sindresorhus/awesome \
[root@server pool0]# 

