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

## Keep OpenDSA-DevStack up to date:

During development of OpenDSA-LTI, other developers might add new gems to the project or add new migrations etc. To keep your local version up to date with the latest version do the following:

1. Open a new terminal
2. `$ cd OpenDSA-DevStack`
3. `$ vagrant reload`
4. `$ vagrant ssh`
5. `$ cd /vagrant/OpenDSA-LTI`
6. `$ git pull`
7. `$ sudo bundle install`
8. `$ rake db:reset_populate` **Note:** This step will place the database in a simple starter state.
9. `$ cd /vagrant/OpenDSA`
10. `$ make pull`
11. `$ cd /vagrant`
12. `$ ./runservers.sh`


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
    - admin@opendsa.org (pass: adminadmin), has admin-level access
    - example-1@railstutorial.org (pass: hokiehokie), has instructor access
    - example-*@railstutorial.org (pass: hokiehokie) 50 students

    It also includes the following other objects:
    - six terms (spring, summer I, summer II, fall, and winter 2016),
    - one organization (VT)
    - one course (CS 1114)
    - two offerings of 1114 (one each semester)
      - one course offering is set up with the admin and instructor
        as instructors, and all other sample accounts as students

## Generate Canvas course using OpenDSA web interface.

1. If you are using OpenDSA-DevStack, make sure it is up to date by following the instructions [here](https://github.com/OpenDSA/OpenDSA-DevStack/blob/master/README.md#keep-opendsa-lti-up-to-date).
2. After you are done you should have OpenDSA-LTI server running. Go to https://192.168.33.10:9292 to make sure your application is up and running.
3. Open a new terminal and do the following to process background jobs:
    - `cd ~/OpenDSA-DevStack`
    - `vagrant ssh`
    - `cd /vagrant/OpenDSA-LTI`
    - `rake jobs:work`
4. Login to the application with admin account (admin@codeworkout.org, pass: 'adminadmin').
5. Click `Upload Books` in the navigation bar, then  click `Choose File`. Navigate to OpenDSA-DevStack/OpenDSA-LTI and choose test_CS3.json. Click `Submit File`.
6. Go to https://canvas.instructure.com/ and create a course with the name `OpenDSA-LTI`. Copy the course ID from the URL, you will use it later.
7. Go to the admin area by clicking on the little wrench icon to the left of "admin@codworkout.org" in the top menu bar. Click the `University-oriented` menu and select `Course Offerings`. There are six course offerings in three semesters, Spring-2016 (1/1-5/31), Summer-I (6/1-7/15), and Summer-II (7/16-8/15). Pick one and click `edit`. At the top of the form, select `https://canvas.instructure.com` from the menu.
Also, modify `LMS COURSE CODE` to be 'OpenDSA-LTI' and `LMS COURSE NUM` to the course ID you copied in point #6.
Click on `Update Course offering` at the bottom of the page.
8. Under the `ODSA Books` menu, select `Inst Book`. Then click on `edit` for the chosen book-to-course mapping entry. On the edit form, select the proper course instance (the one that you updated in the previous step). Click `Update Inst book`.
9. Under the `LMS config` menu, click `Lms Access`. Give instructor `Ima Teacher` access to the Canvas instance. Click `create access`, then set the LMS instance and the User. Put some dummy value in the token field. Click `Create Lms access`.
10. Log out and log in again using the instructor account `example-1@railstutorial.org`, password: 'hokiehokie'. This is the `Ima Teacher` account. Click on the instructor email address in the navigation bar, then click `Update Access Token`. If you don't have Canvas access token follow the instructions [here](https://guides.instructure.com/m/4214/l/40399-how-do-i-obtain-an-api-access-token-for-an-account). Click `Edit` for the `LMS instance`. Set the access token, and click `Update Lms access`.
11. Go back to the application main page by following this link https://192.168.33.10:9292. Click the `Course` button and then navigate to the course that you have previously selected. Under the `OpenDSA` tab you will find the book linked to that offering. You can click `Configure Book` to go to book configuration view. This allows an instructor to add/remove book modules and chapters. It also allows an instructor to define exercises points and due dates. Clicking the `Compile Book` button will then generate the book's html files on the server file system, and send book details to the linked Canvas instance as well. Click `Compile Book` and you should see the progress bar moving forward while the course is being generated in Canvas.
12. At this point the book is generated in Canvas and linked to a compiled book on the server file system. But
Since we don't have the book compilation step automated yet, you should compile the book manually.
I've updated the `Makefile` for CS3 book to compile it in the right folder. So you need to open a new terminal and do the following:
    - `cd ~/OpenDSA-DevStack`
    - `vagrant ssh`
    - `cd /vagrant/OpenDSA`
    - `make pull`
    - `make CS3`
13. Once the compilation step is done, go to Canvas and open course modules you should find the book pushed and published.

## Connect to CodeWorkout Database:

During development it is convenient to connect to OpenDSA-LTI database from your host machine using [MySQL Workbench](https://www.mysql.com/products/workbench/). Once you installed MySQL Workbench create a new connection to CodeWorkout Database in the Vagrant machine using the following setup:

- Connection Name: CodeWorkout
- Connection Method: Standard TCP/IP over SSH
- SSH Hostname: 192.168.33.10
- SSH Username: vagrant
- SSH Password: vagrant
- MySQL Hostname: 127.0.0.1
- MySQL Server Port: 3306
- Username: opendsa
- Password: opendsa
