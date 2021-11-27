#Set ssh key. Change with your own key
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCVQlZmBmoHPtqLxepwM0xrBmFv9vOobmq5NW+aINRSsNAgT9bYn6obC67/ol8SzAIWgtt8SwxCkJry/Wj4Kauxm4NbflOR8hWIWqtBHhnYayksW5trm6m7eNpVgZUII46D2bltYCCJP3mwPH5E7OQRI8zZ0p8gWhqtwVaIyP6wyeyP1Az8aHHticfPBVzXxBtJN3oRJFGU90u5gFapnwYJy499Y2TJsBJGJ+q9YLWIAEvUHWHI0OQY9JpedtCdJxgixdT9qCRiwVyu6m0MbHH2QoDmMrZCg8q53UOTPPD6gSOb9aJWHTBt0bwievnaMyC2MJFf8vzaCKay4/GybX19nsKRKLIEadIo2p7BHLx6l014OLhoKT/hRzWpS7RSgP11ZXyPIUxLeqhzuh/ddp1l57WcnBJ/uBOff1lQiHwwFOdLYmYISI1J1VEtd+F156AWYeA+PUK7z9QaBAggJATKH24amzyQLNh441ZIBtH7n45pAkgO/xfnxUhDtXAWZ7E= im@DESKTOP-2L2FRKD" >> /home/vagrant/.ssh/authorized_keys

#Network config
sudo modprobe br_netfilter
sudo cat << EOF | tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
sudo cat << EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --syste   

#Dsiable swap
sudo swapoff -a
sudo sed -i '/swap/ s/^/#/' /etc/fstab  

#Install docker
sudo yum install -y yum-utils
sudo yum-config-manager \
--add-repo \
https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io ca-certificates curl -y
sudo mkdir /etc/docker
sudo cat <<EOF | tee /etc/docker/daemon.json
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
    "max-size": "100m"
},
"storage-driver": "overlay2"
}
EOF
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docke   

#Install kubernetes
sudo cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

#Set hosts
sudo echo "172.20.112.10  k8s-master.k8s k8s-master" | tee -a /etc/hosts
sudo echo "172.20.112.11  node-1.k8s  node-1" | tee -a /etc/hosts
sudo echo "172.20.112.12  node-2.k8s  node-2" | tee -a /etc/hosts 
sudo echo "172.20.112.100  nfs-server" | tee -a /etc/hosts  


#Update all packages
sudo yum update -y 