#!/bin/bash

cd 0-terraform
terraform init
terraform apply -auto-approve

echo "Aguardando criação de maquinas ..."
sleep 10 # 10 segundos

echo "[ec2-fragmento]" > ../1-ansible/hosts # cria arquivo
echo "$(terraform output | grep public_dns | awk '{print $2;exit}')" | sed -e "s/\",//g" >> ../1-ansible/hosts # captura output faz split de espaco e replace de ",

echo "Aguardando criação de maquinas ..."
sleep 20 # 20 segundos

cd ../1-ansible
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key /home/ubuntu/id_rsa
