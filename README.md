Ubuntu 14.04, OpenDSA-DevStack
======

## How to use:

1. Install [Vagrant](http://www.vagrantup.com)
2. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
3. Clone or [Download](https://github.com/OpenDSA/OpenDSA-DevStack/archive/master.zip) this repository
4. `$ cd OpenDSA-DevStack`
5. `$ vagrant up`
6. `$ vagrant ssh`
7. `$ cd /vagrant`
8. `$ ./OpenDSA-Devstack.sh`
9. Go to https://192.168.33.10:8443 for OpenDSA-server
10. Go to https://192.168.33.10:9292 for OpenDSA-LTI server
11. Go to http://192.168.33.10:8080 for OpenDSA content server

##Suspending and Shutting Down Virtual Machine:

<p>After you finish your working, you need either to suspend and resume your virtual machine or turn it off; you can use one of the following commands upon your choice.</p>

1. `$ vagrant suspend`
2. `$ vagrant resume`
3. `$ vagrant halt`