#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

echo -e "${red} 安装k8s-master节点${plain}"
mkdir /k8s
cd /k8s
wget https://github.com/qiangwum/script/blob/main/k8s-plugin.sh && sh k8s-plugin.sh
#获取master节点ip
master_ip=`ifconfig | grep -A 2 ^e.* |sed -n '2p'|sed -n 's/^.*inet//p'|awk '{ print $1 }'`
# k8s master节点初始化
kubeadm init --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.16.0 --apiserver-advertise-address $master_ip --pod-network-cidr=10.244.0.0/16 --token-ttl 0

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubeadm token create --print-join-command > /b.sh

echo -e "${red}安装flannel${plain}"
wget https://gitee.com/guoshaosong/scripts/raw/master/kube-flannel.yml
kubectl apply -f kube-flannel.yml

#远程登录node节点
read -ep "请输入k8s-node节点ip,以空格进行分割.与/etc/hosts/下主机名顺序保持一致:" ip_array
for node_ip in $ip_array
do
scp /b.sh root@$node_ip:/b.sh
ssh root@$node_ip <<EOF
wget https://github.com/qiangwum/script/blob/main/k8s-plugin.sh && sh k8s-plugin.sh && sh /b.sh
# 安装kubeadm、kubectl、kubelet
exit
EOF
done


echo "${yellow}现在是master节点${plain}"
echo "${red}  部署 Dashboard ${plain}"
wget https://gitee.com/guoshaosong/scripts/raw/master/dashboard.yaml
cd /k8s
kubectl apply -f dashboard.yaml
