#Set ssh key. Change with your own key
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4o88KvZhwvw2vK1YuAqcQctuch3HRrMD0twWRGix0KpBOMou40cOX1KiVA4nkUAhUjrexpFr47h6uFybKNdLBo2Q4LrWyb2gIvP96dmHzSvu8AW204Lf3LcodvTq2oAW+HUGv3P2shcVE2cezOXqCZl2THW+G+AJ6RdedDyjfSuWvQ7yIkOPpwqmEL09FORkeV7hLa9Dh1w72YKEZW72lJEsI1BtimaT6DvCmmDkDfnEhLyUo8OnvLZkLl83q87sTlNtEozKjOK7/TCD9GZcDBhTsw7nCOcsyqLxruk/e01ni9hFbzcx9rM18A1s2IMBKrNXFhrbtuDp/olL4GFQB250NmR8vx2UbwDsFJqTpwFZ9oEUuGpRCsfh9QOIA852VmqQ1NgFSsoI4NrkEQ+p+/OIE2b08t2qp2jEVlT6ZxqfEcwo/Ac0StYSPLzml91+GVouWr9bwBWLTFjTcHUvyyIot99bapQB8rpEI5DywLN+LVWQUYUVQCV4qeKZOxcc= imarinov@imarinov-win11" >> /home/vagrant/.ssh/authorized_keys

#Update all packages
sudo yum update -y 

#Network config
sudo modprobe br_netfilter
sudo cat << EOF | tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --syste   

#Disable swap
sudo swapoff -a
sudo sed -i '/swap/ s/^/#/' /etc/fstab  

#Install cri-o
VERSION=1.24
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/CentOS_7/devel:kubic:libcontainers:stable.repo
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:${VERSION}.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:${VERSION}/CentOS_7/devel:kubic:libcontainers:stable:cri-o:${VERSION}.repo
sudo yum install cri-o cri-tools -y 
sudo systemctl enable --now crio

#Install kubernetes
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
rpm --import https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable kubelet.service

#Set hosts
sudo echo "172.20.112.10  k8s-master.k8s k8s-master" | tee -a /etc/hosts
sudo echo "172.20.112.11  node-1.k8s  node-1" | tee -a /etc/hosts
sudo echo "172.20.112.12  node-2.k8s  node-2" | tee -a /etc/hosts 

