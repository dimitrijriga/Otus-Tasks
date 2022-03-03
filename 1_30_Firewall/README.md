                      inetRouter(curl 8080 port) <---> centralRouter <---> centralServer(nginx 80 port) 

vagrant up \ 
ansible-playbook ansible/provision.yml -i inventory --limit inetRouter \
ansible-playbook ansible/provision.yml -i inventory --limit centralRouter \
ansible-playbook ansible/provision.yml -i inventory --limit centralServer 

vagrant ssh inetRouter \
sudo systemctl restart network \
ping 192.168.0.2 \
curl http://192.168.0.2:8080

vagrant ssh centralRouter \
ssh 192.168.255.1 --- not connection \
cat knock.sh \
./knock.sh 192.168.255.1 8881 7777 9991 \
ssh 192.168.255.1 --- connected \
password: vagrant 


