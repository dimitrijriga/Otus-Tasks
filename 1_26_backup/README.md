vagrant up --no-provision && vagrant provision  \
client с него сохраняются рез.копии /etc \
backup в /var/backup сохраняются рез.копии, полный путь /var/backup/etc 

Не смог настроить в playbook.yml выполнение init borg репозитория 

[root@client ~]# ssh borg@192.168.56.160 --- ОБЯЗАТЕЛЬНО проверить что работает подключение по ключу \
Когда обе VM запущены нужно на client выполнить : \
export BORG_PASSPHRASE="otus" \
borg init --encryption=keyfile borg@192.168.56.160:/var/backup/etc/  

systemctl start borg-backup.service --- для ручного запуска \
остальное должно начать работать сразу после выполнения инициализации borg \
systemctl status borg-backup.timer \
journalctl -u borg-backup.service --- просмотр логов \
systemctl restart borg-backup.timer --- если не работает \
systemctl daemon-reload --- если вносились изменения в /etc/systemd/system/borg-backup.timer или в /etc/systemd/system/borg-backup.service \
borg list borg@192.168.56.160:/var/backup/etc/ --- список копий на сервере 

borg prune -v --list --dry-run --keep-daily=10 borg@192.168.56.160:/var/backup/etc/ --- для настройки удаления нужно проверить "что останется?" 

Восстановление файла из рез.копии, можно восстановить всю директорию \
[root@client ~]# borg extract borg@192.168.56.160:/var/backup/etc/::etc-2022-02-18_16:32:29 etc/hostname \
[root@client ~]# ll \
total 16 \
-rw-------. 1 root root 5570 May  1  2020 anaconda-ks.cfg \
drwx------. 2 root root   22 Feb 18 16:58 etc \
-rw-------. 1 root root 5300 May  1  2020 original-ks.cfg \
[root@client ~]# ll etc/ \
total 4 \
-rw-r--r--. 1 root root 7 Feb 18 15:39 hostname \
[root@client ~]# date \
Fri Feb 18 16:58:37 EET 2022 \
[root@client ~]# 

 
