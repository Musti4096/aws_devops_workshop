#! /bin/bash
apt-get update -y
apt-get upgrade -y
hostnamectl set-hostname kube18-master
apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubectl kubeadm kubelet kubernetes-cni docker.io
systemctl start docker
systemctl enable docker
systemctl start kubelet
systemctl enable kubelet
usermod -aG docker ubuntu
newgrp docker
cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
kubeadm config images pull
kubeadm init --pod-network-cidr=172.16.0.0/16 --ignore-preflight-errors=NumCPU
mkdir -p /home/ubuntu/.kube
cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube/config
su - ubuntu -c 'kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml'