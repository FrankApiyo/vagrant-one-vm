# Vagrantfile
Vagrant.configure("2") do |config|
  # Use Ubuntu 20.04 as the base box
  config.vm.box = "ubuntu/focal64"

  # Set up the VM hostname
  config.vm.hostname = "linux-vm"

  # Configure the VM provider (VirtualBox in this case)
  config.vm.provider "virtualbox" do |vb|
    vb.name = "LinuxVM"               # Name shown in VirtualBox
    vb.memory = "1024"               # Allocate 1GB RAM
    vb.cpus = 1                      # Allocate 1 CPU
  end

  config.vm.network "private_network", ip: "192.168.56.10"

  # Sync a folder from the host to the VM
  config.vm.synced_folder "./data", "/vagrant_data"

  # Provision the VM with a simple script
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y htop
    cat /vagrant_data/id_ed25519.pub >> /home/vagrant/.ssh/authorized_keys
    sudo apt-get install acl
  SHELL
end

