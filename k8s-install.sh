#!/bin/bash

#master节点执行
mkdir /k8s
cd /k8s

#获取master节点ip,需要先安装net-tools
master_ip=`ifconfig | grep -A 2 ^e.* |sed -n '2p'|sed -n 's/^.*inet//p'|awk '{ print $1 }'`
# k8s master节点初始化
kubeadm init --image-repository registry.aliyuncs.com/google_containers --kubernetes-version=v1.16.0 --apiserver-advertise-address $master_ip --pod-network-cidr=10.244.0.0/16 --token-ttl 0

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

##如果不能下载就手动复制吧
wget https://raw.githubusercontent.com/qiangwum/script/main/kube-flannel.yml
kubectl apply -f kube-flannel.yml


###最后把各个node节点加入master就安装完成了


