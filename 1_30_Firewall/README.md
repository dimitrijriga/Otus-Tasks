vagrant up inetRouter \ 
ansible-playbook ansible/provision.yml -i inventory --limit inetRouter \
vagrant up centralRouter \
ansible-playbook ansible/provision.yml -i inventory --limit centralRouter \
vagrant ssh centralRouter \
ssh 192.168.255.1 --- not connection \
cat knock.sh \
./knock.sh 192.168.255.1 8881 7777 9991 \
ssh 192.168.255.1 --- connected \
password: vagrant \


