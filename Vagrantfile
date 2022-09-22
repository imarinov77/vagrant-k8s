IMAGE_NAME = "centos/7"
N = 2

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.vm.provider "hyperv" do |v|
        v.memory = 2048
        v.cpus = 2
    end
      
    config.vm.define "k8s-master" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "public_network", bridge: "k8s"
        master.vm.hostname = "k8s-master"
		master.vm.provision "shell" do |s|
            s.inline = <<-SHELL
		    conn=`nmcli connection show | awk 'NR>1 {print $3}'`
            nmcli con mod $conn ipv4.addresses 172.20.112.10/20
            nmcli con mod $conn ipv4.gateway 172.20.112.1
            nmcli con mod $conn ipv4.method manual
            nmcli con mod $conn ipv4.dns "8.8.8.8"
            systemctl restart network
            SHELL
        master.vm.provision "shell", path: "common.sh"
        end
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "public_network", bridge: "k8s"
            node.vm.hostname = "node-#{i}"
            node.vm.provision "shell" do |s|
                s.inline = <<-SHELL
                conn=`nmcli connection show | awk 'NR>1 {print $3}'`
                nmcli con mod $conn ipv4.addresses 172.20.112.#{i + 10}/20
                nmcli con mod $conn ipv4.gateway 172.20.112.1
                nmcli con mod $conn ipv4.method manual
                nmcli con mod $conn ipv4.dns "8.8.8.8"
                systemctl restart network
                SHELL
            node.vm.provision "shell", path: "common.sh"
            end
        
        end

    end

end
