Vagrant.configure('2') do |config|
  config.vm.box = "ubuntu/bionic64"
  # config.ssh.extra_args = ["-v"] # have verbose ssh output to debug
  # config.vm.synced_folder ".", "/home/vagrant/OpenDSA-DevStack"
  # WARNING: This^ overwrites any folders that already exist.  Choose a path that doesn't exist!
  config.vm.network "private_network", ip: "192.168.33.10"
  #config.vm.network "forwarded_port", guest: 8080, host: 8080 # OpenDSA content server
  #config.vm.network "forwarded_port", guest: 9292, host: 9292 # OpenDSA-LTI server
  #config.vm.network "forwarded_port", guest: 9293, host: 9293 # CodeWorkout server
  #config.vm.network "forwarded_port", guest: 3306, host: 3306 # mysql server
  config.vm.provision :shell,privileged: false, path: 'bootstrap.sh'
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4048"
    vb.cpus = 2
  end
end
