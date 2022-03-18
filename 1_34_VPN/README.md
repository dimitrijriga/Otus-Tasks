vagrant up \ 
создастся стенд как на картинке 

Проверка TAP \
vagrant ssh centralRouter \
ip a \
tap0: .......  \
    inet 10.10.10.1/24 \
[vagrant@centralRouter ~]$ ping 10.10.10.2 \
PING 10.10.10.2 (10.10.10.2) 56(84) bytes of data. \
64 bytes from 10.10.10.2: icmp_seq=1 ttl=64 time=0.780 ms 

Проверка TUN \
vagrant ssh centralRouter2 \
ip a \
tun0: .......  \
    inet 10.11.11.1/24 \
[vagrant@centralRouter ~]$ ping 10.11.11.2 \
PING 10.11.11.2 (10.10.10.2) 56(84) bytes of data. \
64 bytes from 10.11.11.2: icmp_seq=1 ttl=64 time=0.870 ms 

vagrant ssh inetRouter \
sudo -i  \ 
systemctl start openvpn@server.service 

Проверка RAS, на локальном ПК, на котором запущен vagrant стенд, \
cd ras_vpn \ 
cp inetRouter/etc/openvpn/pki/ca.crt ./  \
cp inetRouter/etc/openvpn/pki/issued/client.crt ./  \
cp inetRouter/etc/openvpn/pki/private/client.key ./  \
sudo openvpn --config client.conf \
ip a | grep 10.10. \
ping 10.10.10.1 \

Результат замера скорости \
TAP \
[root@centralServer ~]# iperf3 -c 10.10.10.1 -t 40 -i 5 \
Connecting to host 10.10.10.1, port 5201 \
[  4] local 10.10.10.2 port 36410 connected to 10.10.10.1 port 5201 \
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd \
[  4]   0.00-5.00   sec   100 MBytes   168 Mbits/sec   49   1.20 MBytes \
[  4]   5.00-10.01  sec  97.1 MBytes   163 Mbits/sec    6   1.05 MBytes \
[  4]  10.01-15.00  sec  97.1 MBytes   163 Mbits/sec    0   1.07 MBytes \
[  4]  15.00-20.00  sec  97.3 MBytes   163 Mbits/sec    0   1.20 MBytes \
[  4]  20.00-25.01  sec  97.2 MBytes   163 Mbits/sec    3   1.19 MBytes \
[  4]  25.01-30.01  sec  95.9 MBytes   161 Mbits/sec    2   1.00 MBytes \
[  4]  30.01-35.01  sec  97.1 MBytes   163 Mbits/sec    0   1.06 MBytes \
[  4]  35.01-40.00  sec  97.1 MBytes   163 Mbits/sec    0   1.13 MBytes \
[ ID] Interval           Transfer     Bandwidth       Retr \
[  4]   0.00-40.00  sec   779 MBytes   163 Mbits/sec   60             sender \
[  4]   0.00-40.00  sec   777 MBytes   163 Mbits/sec                  receiver \
iperf Done.

TUN \
[root@centralServer2 ~]# iperf3 -c 10.11.11.1 -t 40 -i 5 \
Connecting to host 10.11.11.1, port 5201 \
[  4] local 10.11.11.2 port 60942 connected to 10.11.11.1 port 5201 \
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd \
[  4]   0.00-5.00   sec   106 MBytes   178 Mbits/sec   20    481 KBytes \
[  4]   5.00-10.00  sec   110 MBytes   184 Mbits/sec    0    617 KBytes \
[  4]  10.00-15.00  sec   109 MBytes   183 Mbits/sec    2    627 KBytes \
[  4]  15.00-20.01  sec   110 MBytes   184 Mbits/sec    2    558 KBytes \
[  4]  20.01-25.00  sec   109 MBytes   183 Mbits/sec    2    551 KBytes \
[  4]  25.00-30.00  sec   109 MBytes   183 Mbits/sec    2    491 KBytes \
[  4]  30.00-35.00  sec   110 MBytes   184 Mbits/sec    0    623 KBytes \
[  4]  35.00-40.00  sec   109 MBytes   183 Mbits/sec    2    632 KBytes \
[ ID] Interval           Transfer     Bandwidth       Retr \
[  4]   0.00-40.00  sec   871 MBytes   183 Mbits/sec   30             sender \
[  4]   0.00-40.00  sec   870 MBytes   182 Mbits/sec                  receiver \
iperf Done.
