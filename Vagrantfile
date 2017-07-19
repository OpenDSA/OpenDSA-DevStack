Vagrant.configure('2') do |config|
  config.vm.box = "IE10_Win7"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network :public_network
  config.vm.provision :shell, path: 'bootstrap.sh'
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4048"
    vb.cpus = 2
  end
end