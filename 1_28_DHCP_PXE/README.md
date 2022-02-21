vagrant up pxeserver \
ansible-playbook ansible/provision.yml -i inventory \
после этого основные настройки PXE сервера выполнены \
далее нужно скачать ISO DVD 10GB \
скопировать его на pxeserver, раскомментировать последние строки в ansible/provision.yml \
выполнить ещё раз \
ansible-playbook ansible/provision.yml -i inventory \
после этого нужно проверить загрузку по сети \
vagrant up pxeclient \
идём в интерфейс VirtualBox, выключаем pxeclient, меняем сеть на pxenet, ставим загрузку только по сети \
включаем pxeclient - проверяем .....
