## Toute commande doit-ere exécution dans le répertoire contenant le Dockerfile
# vagrant up
# vagrant halt
# vagrant destroy
# vagrant global-config
#----------------------
# vagrant ssh [NAME|ID]
# access-token: myusine xYph6TpAt1yJ1hJiS3QN
Vagrant.configure(2) do |config|
  # interface réseau à utiliser (ipconfig /all)
  int = "Intel(R) Ethernet Connection (7) I219-LM #2"
  # gamme d'ip à utiliser
  ip = "192.168.1.42"
  # masque de sous réseau
  cidr = "24"
  [
    ["gitlab.myusine.fr", "8192", "4", "mlamamra/myusine"],
  ].each do |vmname,mem,cpu,os|
    config.vm.define "#{vmname}" do |machine|

      machine.vm.provider "virtualbox" do |v|
        v.memory = "#{mem}"
        v.cpus = "#{cpu}"
        v.name = "#{vmname}"
        v.customize ["modifyvm", :id, "--ioapic", "on"]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end
      machine.vm.box = "#{os}"
      machine.vm.hostname = "#{vmname}"
      # machine.vm.network "public_network"
	    machine.vm.network "public_network",
        bridge: "#{int}",
        ip: "#{ip}",
        netmask: "#{cidr}"
      machine.ssh.insert_key = false
    end
  end
end
