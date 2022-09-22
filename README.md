#Configure Hyper-V network

Create new internal virtula switch in hyper-v

	New-VMSwitch -SwitchName "k8s" -SwitchType Internal

Find the interface index of the new virtual switch 

	Get-NetAdapter
	
Set IP address.Find ifIndex from the previous command

	New-NetIPAddress -IPAddress 172.20.112.1 -PrefixLength 20 -InterfaceIndex <ifIndex>

Configure the NAT network using New-NetNat

	New-NetNat -Name MyNATnetwork -InternalIPInterfaceAddressPrefix 172.20.112.0/20

More information - https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-guide/setup-nat-network

#Vagrant

Genereate a new ssh keys and add the pub key in common.sh 

Run powershell in admin mode and execute:

	vagrant up

#Create k8s cluster 

Init master node k8s-master 
	
	kubeadm init --apiserver-advertise-address=172.20.112.10    --pod-network-cidr=192.168.0.0/16

	mkdir $HOME/.kube

	cp -r /etc/kubernetes/admin.conf $HOME/.kube/config

	kubectl apply -f https://projectcalico.docs.tigera.io/manifests/calico-typha.yaml

Init worker - follow instructions from master init
	
