Setting Up Vagrant Environment For OpenDSA Project
======

## Introduction:

Vagrant designed to run through multiple platforms including currently Mac OS X, Microsoft Windows, Debian, Ubuntu, CentOS, RedHat and Fedora, in this document we will handle how to configure and run OpenDSA project virtual development environment through Vagrant from scratch to up and running.

## Installation Steps:

1. Install [Vagrant](https://www.vagrantup.com/downloads)
2. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
3. Clone or [Download](https://github.com/OpenDSA/OpenDSA-DevStack/archive/master.zip) this repository
4. `$ cd OpenDSA-DevStack`
5. `$ vagrant up`
6. `$ vagrant ssh`
7. `$ cd /vagrant`
8. `$ ./OpenDSA-DevStack.sh`
9. Enter MySQL root password as `root` when prompted
10. When prompted to create django superuser account enter username: `opendsa`, password:`opendsa`, and any email address
11. After the provisioning script complete you can go to:

  * https://192.168.33.10:8443 for OpenDSA-server
  * https://192.168.33.10:9292 for OpenDSA-LTI server
  * http://192.168.33.10:8080 for OpenDSA content server

## Shut Down The Virtual Machine:

After you finish your work, you need to turn the virtual machine off.

1. Exit the virtual machine terminal by typing `exit`
2. `$ cd OpenDSA-DevStack`
3. `$ vagrant halt`

## Re-run Development Servers:

If you decided to shut down the virtual machine using `vagrant halt`, you have to re-run the servers again after you do `vagrant up`.

1. `$ cd OpenDSA-DevStack`
2. `$ vagrant up`
3. `$ vagrant ssh`
4. `$ cd /vagrant`
5. `$ ./runservers.sh`

## Reprovision The Virtual Machine:

If anything went wrong or you want to reprovision your virtual machine for any reasons follow these steps.

1. `$ cd OpenDSA-DevStack`
2. `$ vagrant destroy`
3. `$ rm -rf OpenDSA`
4. `$ rm -rf OpenDSA-LTI`
5. `$ rm -rf OpenDSA-server`
6. `$ vagrant up`
7. `$ vagrant ssh`
8. `$ cd /vagrant`
9. `$ ./OpenDSA-DevStack.sh`
10. Enter MySQL root password and create django superuser as described before.

## Virtual Machine sudo password:

sudo password is `vagrant` in case you need to execute any commands the require sudo.

## Development Workflow:

Provisioning script will clone OpenDSA, OpenDSA-LTI, and OpenDSA-server repositories inside OpenDSA-DevStack folder. OpenDSA-DevStack folder is shared between your host machine and the virtual machine so you can do your development to any of these repositories on your host machine using your preferred tools or IDEs. All changes you make will take effect immediately and you can test them through the virtual machine servers URLs provided earlier. You can commit and push your changes from your host machine however if you want to compile books in OpenDSA folder you have to do that within the virtual machine as following:

1. Open new terminal in your host machine
2. `$ cd OpenDSA-DevStack`
3. `$ vagrant ssh` (you don't need to do `vagrant up` because we assume that VM is already up and running)
4. `$ cd /vagrant/OpenDSA`
5. `make <<CONFIG_FILE_NAME>>`
