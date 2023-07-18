#!/bin/bash
# run in all 2 nodes and controller
apt -y update
sleep 2
apt -y upgrade
sleep 2
apt install docker.io apt-transport-https curl -y
systemctl restart docker
systemctl enable docker
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add
apt-add-repository --yes --update "deb https://apt.kubernetes.io/ kubernetes-xenial main"
apt -y update
sleep 2
apt install kubeadm kubectl kubelet -y
apt-mark hold kubeadm kubectl kubelet
swapoff -a
free -mh
sleep 5

# run folllowing only in k8s controller
kubeadm init --pod-network-cidr=10.244.0.0/16
export KUBECONFIG=/etc/kubernetes/admin.conf
sleep 2
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
echo "========\n"
echo "get nodes\n"
sleep 30
kubectl get nodes
