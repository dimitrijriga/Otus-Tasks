vagrant up \
centos-client с него сохраняются рез.копии /etc \
centos-backup в /var/backup сохраняются рез.копии, полный путь /var/backup/etc \
Не смог отделить на sda место для монтирования отдельного разделана котором хранились бы рез.копии \
Не смог настроить в playbook.yml выполнение init borg репозитория \
Поэтому, когда обе VM запущены нужно на centos-client выполнить : \
export BORG_PASSPHRASE="otus" \
borg init --encryption=keyfile borg@192.168.56.160:/var/backup/etc/  \
остальное должно начать работать сразу после выполнения инициализации borg

