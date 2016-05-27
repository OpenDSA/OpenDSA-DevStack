Setting Up a Vagrant Environment for OpenDSA
============================================

## Introduction:

Vagrant is designed to run on multiple platforms, including Mac OS X, Microsoft Windows, Debian, Ubuntu, CentOS, RedHat and Fedora. In this document we describe how to configure and run an OpenDSA project virtual development environment through Vagrant.

## Installation Steps:

1. Install [Vagrant](https://www.vagrantup.com/downloads.html)
2. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
3. Clone or [Download](https://github.com/OpenDSA/OpenDSA-DevStack/archive/master.zip) this repository
4. `$ cd OpenDSA-DevStack`
5. `$ vagrant up`
6. `$ vagrant ssh`
7. `$ cd /vagrant`
8. `$ ./runservers.sh`
9. After the provisioning script is complete you can go to:

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

If anything went wrong or you want to reprovision your virtual machine for any reason, follow these steps.

1. `$ cd OpenDSA-DevStack`
2. `$ git pull`
3. `$ vagrant destroy`
4. `$ vagrant up`

## Virtual Machine sudo password:

sudo password is `vagrant` in case you need to execute any commands that require sudo.

## Development Workflow:

The provisioning script will clone the OpenDSA, OpenDSA-LTI, and OpenDSA-server repositories inside the OpenDSA-DevStack directory. OpenDSA-DevStack directory is shared between your host machine and the virtual machine, so you can do your development to any of these repositories on your host machine using your preferred tools or IDEs (from "outide" the virtual machine). All changes you make will take effect immediately, and you can test them through the virtual machine server URLs provided earlier. You can commit and push your changes from your host machine. **However, if you want to compile books in OpenDSA, you have to do that from within the virtual machine.** Do so as follows:

1. Open a new terminal within your virtual machine
2. `$ cd OpenDSA-DevStack`
3. `$ vagrant ssh` (you don't need to do `vagrant up` if the VM is already up and running)
4. `$ cd /vagrant/OpenDSA`
5. `make <<CONFIG_FILE_NAME>>`

## Keep OpenDSA-LTI up to date:

During development of OpenDSA-LTI, other developers might add new gems to the project or add new migrations etc. To keep you local version up to date with the latest version do the following:

1. Open a new terminal
2. `$ cd OpenDSA-DevStack`
3. `$ vagrant reload`
4. `$ vagrant ssh`
5. `$ cd /vagrant/OpenDSA-LTI`
6. `$ git pull`
7. `$ sudo bundle install`
8. `$ rake db:reset_populate` **Note:** This step will place the database in a simple starter state.
9. `$ cd /vagrant`
10. `$ ./runservers.sh`


## OpenDSA-LTI Database Test Data


The initial database population is defined by lib/tasks/sample_data.rake.
It uses the factories defined in spec/factories/* to generate entities.
If you add new modael classes and want to generate test data in the
database, please add to the sample_data.rake file so that this population
will happen automatically for everyone.  The sample_data.rake contains
only "sample/try out" data for use during development, and it won't
appear on the production server.  Initial database contents provided
for all new installs, including the production server, is described
in db/seeds.rb instead.

  - The initial database includes the following accounts:
    - admin@codeworkout.org (pass: adminadmin), has admin-level access
    - example-1@railstutorial.org (pass: hokiehokie), has instructor access
    - example-*@railstutorial.org (pass: hokiehokie) 50 students

    It also includes the following other objects:
    - six terms (spring, summer I, summer II, fall, and winter 2016),
    - one organization (VT)
    - one course (CS 1114)
    - two offerings of 1114 (one each semester)
      - one course offering is set up with the admin and instructor
        as instructors, and all other sample accounts as students

## Test within Canvas

1. Create a Canvas Account. If you do not have access to a Canvas installation, then use the public one provided by Instructure at https://canvas.instructure.com.
2. Generate an access token. Under "Account", click "Settings", then at the bottom of the page click "New Access Token". Be sure to copy the token once it is generated for the next step.
3. Put the generated token into a copy of config/template_LMSconf.json
4. In the template, pick a course code for `course_code` (e.g. "course_code": "CS3")
5. Change template_LMSconf.json with your course name (e.g. CS3_LMSconf.json)
6. Go to https://canvas.instructure.com and create a course using the same course code that you chose in the previous step.
7. Go to the vagrant command terminal, cd to `OpenDSA`, and compile a book (e.g. make CS3). You will probably need to add a Makefile target, following the existing examples in the Makefile.
