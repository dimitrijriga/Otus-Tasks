vagrant up --no-provision && vagrant provision  \
client с него сохраняются рез.копии /etc \
backup в /var/backup сохраняются рез.копии, полный путь /var/backup/etc 

Не смог настроить в playbook.yml выполнение init borg репозитория \
[root@centos-client ~]# ssh borg@192.168.56.160 --- проверить что работает подключение по ключу \
Когда обе VM запущены нужно на centos-client выполнить : \
export BORG_PASSPHRASE="otus" \
borg init --encryption=keyfile borg@192.168.56.160:/var/backup/etc/  \
systemctl start borg-backup.service --- для ручного запуска \
остальное должно начать работать сразу после выполнения инициализации borg \
systemctl status borg-backup.timer \
journalctl -u borg-backup.service --- просмотр логов \
systemctl restart borg-backup.timer --- если не работает \
borg list borg@192.168.56.160:/var/backup/etc/ --- список копий на сервере \
 
