vagrant up --no-provision \
ansible-playbook ansible/provision.yml -i inventory --limit inetRouter \
ansible-playbook ansible/provision.yml -i inventory --limit centralRouter \
ansible-playbook ansible/provision.yml -i inventory --limit office1Router \
ansible-playbook ansible/provision.yml -i inventory --limit office2Router \
ansible-playbook ansible/provision.yml -i inventory --limit centralServer \
ansible-playbook ansible/provision.yml -i inventory --limit office1Server \
ansible-playbook ansible/provision.yml -i inventory --limit office2Server 

vagrant ssh inetRouter \
systemctl restart network

vagrant ssh centralServer \
systemctl restart network
