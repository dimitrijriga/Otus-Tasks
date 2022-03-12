#### SELinux: проблема с удаленным обновлением зоны DNS

Инженер настроил следующую схему:

- ns01 - DNS-сервер (192.168.50.10);
- client - клиентская рабочая станция (192.168.50.15).

При попытке удаленно (с рабочей станции) внести изменения в зону ddns.lab происходит следующее:
```bash
[vagrant@client ~]$ nsupdate -k /etc/named.zonetransfer.key
> server 192.168.50.10
> zone ddns.lab
> update add www.ddns.lab. 60 A 192.168.50.15
> send
update failed: SERVFAIL
>
```
Инженер перепроверил содержимое конфигурационных файлов и, убедившись, что с ними всё в порядке, предположил, что данная ошибка связана с SELinux.

В данной работе предлагается разобраться с возникшей ситуацией.


#### Задание

- Выяснить причину неработоспособности механизма обновления зоны.
- Предложить решение (или решения) для данной проблемы.
- Выбрать одно из решений для реализации, предварительно обосновав выбор.
- Реализовать выбранное решение и продемонстрировать его работоспособность.


#### Формат

- README с анализом причины неработоспособности, возможными способами решения и обоснованием выбора одного из них.
- Исправленный стенд или демонстрация работоспособной системы скриншотами и описанием.

#### Описание решения проблемы :
проверяем ошибки SELinux на VM client \
[root@client ~]# cat /var/log/audit/audit.log | audit2why \
[root@client ~]# \
ошибок нет

проверяем ошибки SELinux на VM ns01 \
[root@ns01 ~]# cat /var/log/audit/audit.log | audit2why \
type=AVC msg=audit(1646671477.566:1985): avc: denied { create } for pid=5278 comm="isc-worker0000" \
name="named.ddns.lab.view1.jnl" scontext=system_u:system_r:named_t:s0 \
tcontext=system_u:object_r:etc_t:s0 tclass=file permissive=0 \
Was caused by: Missing type enforcement (TE) allow rule. \
You can use audit2allow to generate a loadable module to allow this access. 

[root@ns01 ~]# ls -laZ /etc/named \
drw-rwx---. root named system_u:object_r:etc_t:s0 . \
drwxr-xr-x. root root system_u:object_r:etc_t:s0 .. \
drw-rwx---. root named unconfined_u:object_r:etc_t:s0 dynamic \
-rw-rw----. root named system_u:object_r:etc_t:s0 named.56.168.192.rev \
-rw-rw----. root named system_u:object_r:etc_t:s0 named.dns.lab \
-rw-rw----. root named system_u:object_r:etc_t:s0 named.dns.lab.view1 \
-rw-rw----. root named system_u:object_r:etc_t:s0 named.newdns.lab

видим что используется не правильный контекст \
etc_t вместо named_zone_t 

Первый вариант, отключаем контроль named_t \
[root@ns01 ~]# semanage permissive -a named_t \
Проверяем 
> [root@client ~]# nsupdate -k /etc/named.zonetransfer.key \
> server 192.168.56.10 \
> zone ddns.lab \
> update add test1.ddns.lab 60 A 192.168.56.15 \
> send \
> quit 

Запись добавилась \
[root@client ~]# dig test1.ddns.lab \
;; QUESTION SECTION: \
;test1.ddns.lab. IN A \
;; ANSWER SECTION: \
test1.ddns.lab. 60 IN A 192.168.56.15 

Второй вариант, меняем контекст безопасности для директории с named \
[root@ns01 ~]# chcon -R -t named_zone_t /etc/named \
Проверяем \
[root@ns01 ~]# ls -laZ /etc/named \
drw-rwx---. root named system_u:object_r:named_zone_t:s0 . \
drwxr-xr-x. root root system_u:object_r:etc_t:s0 .. \
drw-rwx---. root named unconfined_u:object_r:named_zone_t:s0 dynamic \
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.56.168.192.rev \
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.dns.lab \
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.dns.lab.view1 \
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.newdns.lab

Вносим изменения ещё раз - работает \
Выбор за вариантом с изменением контекста безопасности для директории с named \
так как в этом случае контроль за самим процессом будет продолжаться.
