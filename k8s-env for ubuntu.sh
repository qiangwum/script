
#ubuntu  env配置：
swapoff -a
# 修改内核参数
systemctl disable ufw
systemctl stop ufw

# 修改内核参数
modprobe br_netfilter

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

sudo apt-get update && sudo apt-get install -y apt-transport-https curl

sudo curl -s https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -

sudo tee /etc/apt/sources.list.d/kubernetes.list <<-'EOF'
deb https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial main
EOF

sudo apt-get update
#查看可用的版面
apt-cache madison kubeadm
#优化docker参数
mkdir -p /etc/docker
cat <<EOF >/etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "registry-mirrors": ["https://pzpl72fb.mirror.aliyuncs.com"],
  "storage-driver": "overlay2",
  "storage-opts": ["overlay2.override_kernel_check=true"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3"
  }
}
EOF
sudo dpkg --configure -a
apt --fix-broken install -y 
apt-get install -y docker.io

systemctl enable docker 
systemctl start docker
apt-get install -y kubelet=1.22.6-00 kubeadm=1.22.6-00 kubectl=1.22.6-00   


# 启动kubelet服务
systemctl enable kubelet && systemctl start kubelet
#查看需要哪些image
kubeadm config images list --kubernetes-version=v1.22.6   


kubeadm init  --image-repository registry.aliyuncs.com/google_containers --kubernetes-version=v1.22.6   --pod-network-cidr=10.244.0.0/16

kubectl apply -f https://docs.projectcalico.org/v3.10/manifests/calico.yaml

# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
# kubectl apply -f https://docs.projectcalico.org/v3.10/manifests/calico.yaml
