vagrant up \
создается VM, устанавливается nginx, меняется порт nginx на 4881 \
проверяем настройки \
[root@selinux ~]# systemctl status nginx.service \
Active: failed (Result: exit-code) ---- nginx не запущен \
проверяем конфигурацию \
[root@selinux ~]# nginx -t \
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok \
nginx: configuration file /etc/nginx/nginx.conf test is successful \
проверяем настройки SELinux \
[root@selinux ~]# getenforce \
Enforcing \
Устанавливаем утилиты для удобной работы с SELinux \
[root@selinux ~]# yum install policycoreutils policycoreutils-python setools setools-console setroubleshoot

Первый вариант решения проблемы с запуском nginx, отключить SELinux \
[root@selinux ~]# setenforce 0 \
[root@selinux ~]# systemctl start nginx.service \
[root@selinux ~]# systemctl status nginx.service \
Active: active (running) \
nginx запустился 

Второй вариант, отключаем контроль за httpd_t \ \ 
[root@selinux ~]# semanage permissive -a httpd_t \
[root@selinux ~]# systemctl start nginx.service \
[root@selinux ~]# systemctl status nginx.service \
Active: active (running) \
nginx запустился 

Третий вариант, меняем конфигурацию SELinux, разрешаем nginx использовать порт 4881 \
[root@selinux ~]# semanage port -l | grep http_port_t \
http_port_t tcp 80, 81, 443, 488, 8008, 8009, 8443, 9000 \
pegasus_http_port_t tcp 5988 \
[root@selinux ~]# semanage port -a -t http_port_t -p tcp 4881 

[root@selinux ~]# semanage port -l | grep http_port_t \
http_port_t tcp 4881, 80, 81, 443, 488, 8008, 8009, 8443, 9000 \
pegasus_http_port_t tcp 5988 \
[root@selinux ~]# systemctl start nginx.service \
[root@selinux ~]# systemctl status nginx.service \
Active: active (running) \
nginx запустился

Четвертый вариант \
[root@selinux ~]# tail /var/log/audit/audit.log \
type=SERVICE_START msg=audit(1646592972.643:732): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nginx comm="systemd" \
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success' \
type=MAC_POLICY_LOAD msg=audit(1646592994.342:733): policy loaded auid=1000 ses=3 \
type=SYSCALL msg=audit(1646592994.342:733): arch=c000003e syscall=1 success=yes exit=3882036 a0=4 a1=7f7c62981000 a2=3b3c34 a3=7ffe82654fe0 items=0 ppid=21504 \
pid=21508 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=3 comm="load_policy" exe="/usr/sbin/load_policy" \
subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null) \
type=PROCTITLE msg=audit(1646592994.342:733): proctitle="/sbin/load_policy" \
type=USER_AVC msg=audit(1646592995.976:734): pid=368 uid=81 auid=4294967295 ses=4294967295 subj=system_u:system_r:system_dbusd_t:s0-s0:c0.c1023 msg='avc: received \
policyload notice (seqno=5) exe="/usr/bin/dbus-daemon" sauid=81 hostname=? addr=? terminal=?' \
type=SERVICE_STOP msg=audit(1646592999.807:735): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nginx comm="systemd" \
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success' \
type=AVC msg=audit(1646593001.944:736): avc: denied { name_bind } for pid=21525 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 \
tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0 \
type=SYSCALL msg=audit(1646593001.944:736): arch=c000003e syscall=49 success=no exit=-13 a0=7 a1=563903dc78a8 a2=1c a3=7ffce3c56744 items=0 ppid=1 pid=21525 \
auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="nginx" exe="/usr/sbin/nginx" subj=system_u:system_r:httpd_t:s0 \
key=(null) \
type=PROCTITLE msg=audit(1646593001.944:736): proctitle=2F7573722F7362696E2F6E67696E78002D74 \
type=SERVICE_START msg=audit(1646593001.944:737): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nginx comm="systemd" \
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=failed' \
[root@selinux ~]# grep 1646593001.944:736 /var/log/audit/audit.log | audit2why \
type=AVC msg=audit(1646593001.944:736): avc: denied { name_bind } for pid=21525 comm="nginx" src=4881 \
scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0 \
Was caused by: \
The boolean nis_enabled was set incorrectly. \
Description: \
Allow nis to enabled \
Allow access by executing: \
# setsebool -P nis_enabled 1 

[root@selinux ~]# setsebool -P nis_enabled 1 \
[root@selinux ~]# systemctl start nginx.service \
[root@selinux ~]# systemctl status nginx.service \
Active: active (running) \
nginx запустился
