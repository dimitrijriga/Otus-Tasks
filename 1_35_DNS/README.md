# Описание решения.

vagrant up , после загрузки получается рабочий стенд, с реализацией "как в задании" \
ns01 - DNS сервер резолвит все имена, не только локальные \
с client и client2 проверяем локальные ресурсы, убеждаемся что всё корректно 

# Описание задания 
завести в зоне dns.lab имена: \
web1 - смотрит на клиент1 \
web2 - смотрит на клиент2 \
завести еще одну зону newdns.lab \
завести в ней запись \
www - смотрит на обоих клиентов \
настроить split-dns \
клиент1 - видит обе зоны, но в зоне dns.lab только web1 \
клиент2 видит только dns.lab \
! настроить все без выключения selinux Формат сдачи ДЗ - vagrant + ansible



# Vagrant DNS Lab

A Bind's DNS lab with Vagrant and Ansible, based on CentOS 7.

# Playground

<code>
    vagrant ssh client
</code>

  * zones: dns.lab, reverse dns.lab and ddns.lab
  * ns01 (192.168.50.10)
    * master, recursive, allows update to ddns.lab
  * ns02 (192.168.50.11)
    * slave, recursive
  * client (192.168.50.15)
    * used to test the env, runs rndc and nsupdate
  * zone transfer: TSIG key
