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

run powershell in admin mode and execute:

	vagrant up
