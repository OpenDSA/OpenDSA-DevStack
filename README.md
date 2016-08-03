Setting Up a Vagrant Environment for OpenDSA
============================================

## Introduction:

Vagrant is designed to run on multiple platforms, including Mac OS X, Microsoft Windows, Debian, Ubuntu, CentOS, RedHat and Fedora. In this document we describe how to configure and run an OpenDSA project virtual development environment through Vagrant.

## Installation Steps:

1. Install [Vagrant](https://www.vagrantup.com/downloads.html)
2. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
3. Clone this repository
4. `$ cd OpenDSA-DevStack`
5. `$ vagrant up`
6. `$ vagrant ssh`
7. `$ cd /vagrant`
8. `$ ./runservers.sh`
9. After the provisioning script is complete you can go to:

  * http://192.168.33.10:8080 for OpenDSA content server
  * https://192.168.33.10:9292 for OpenDSA-LTI server
  * https://192.168.33.10:9200 for code-workout server

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

The provisioning script will clone the OpenDSA, OpenDSA-LTI, and code-workout repositories inside the OpenDSA-DevStack directory. OpenDSA-DevStack directory is shared between your host machine and the virtual machine, so you can do your development to any of these repositories on your host machine using your preferred tools or IDEs (from "outide" the virtual machine). All changes you make will take effect immediately, and you can test them through the virtual machine server URLs provided earlier. You can commit and push your changes from your host machine. **However, if you want to compile books in OpenDSA, you have to do that from within the virtual machine.** Do so as follows:

1. Open a new terminal within your virtual machine
2. `$ cd OpenDSA-DevStack`
3. `$ vagrant ssh` (you don't need to do `vagrant up` if the VM is already up and running)
4. `$ cd /vagrant/OpenDSA`
5. `make <<CONFIG_FILE_NAME>>`

## Keep OpenDSA-DevStack up to date:

Other developers might make changes to any of the repositories cloned by the OpenDSA-DevStack. To keep your local version up to date with the latest version do the following:

1. Open a new terminal
2. `$ cd OpenDSA-DevStack`
3. `$ vagrant reload`
4. `$ vagrant ssh`
5. `$ cd /vagrant/OpenDSA-LTI`
6. `$ git pull`
7. `$ sudo bundle install`
8. `$ bundle exec rake db:reset_populate` **Note:** This step will place the `opendsa` database in a simple starter state.
9. `$ cd /vagrant/code-workout`
10. `$ git pull`
11. `$ sudo bundle install`
12. `$ bundle exec rake db:populate` **Note:** This step will place the `codeworkout`  database in a simple starter state.
13. `$ cd /vagrant/OpenDSA`
14. `$ make pull`
15. `$ cd /vagrant`
16. `$ ./runservers.sh`


## `opendsa` and `codeworkout` Databases Test Data


The initial database population is defined by lib/tasks/sample_data.rake.
It uses the factories defined in spec/factories/* to generate entities.
If you add new model classes and want to generate test data in the
database, please add to the sample_data.rake file so that this population
will happen automatically for everyone.  The sample_data.rake contains
only "sample/try out" data for use during development, and it won't
appear on the production server.  Initial database contents provided
for all new installs, including the production server, is described
in db/seeds.rb instead.

  - `opendsa` database includes the following **admin** account:
    - admin@opendsa.org (pass: adminadmin)
  - `codeworkout` database includes the following **admin** account:
    - admin@codeworkout.org (pass: adminadmin)
  - Both `opendsa` and `codeworkout` databases include the following accounts:
    - example-1@railstutorial.org (pass: hokiehokie), has instructor access
    - example-*@railstutorial.org (pass: hokiehokie) 50 students

    It also includes the following other objects:
    - Five terms (Spring, Summer I, Summer II, Fall, and Winter 2016),
    - one organization (VT)
    - one course (CS 1114)
    - two offerings of 1114 (one each term)
      - one course offering is set up with the admin and instructor
        as instructors, and all other sample accounts as students

## Generate Canvas course using OpenDSA web interface.

1. Make sure OpenDSA-DevStack is up to date by following the instructions [here](https://github.com/OpenDSA/OpenDSA-DevStack/blob/master/README.md#keep-opendsa-devstack-up-to-date).
2. After you are done you should have OpenDSA-LTI server running. Go to https://192.168.33.10:9292 to make sure your application is up and running.
3. Open a new terminal and do the following to process background jobs:
    - `cd ~/OpenDSA-DevStack`
    - `vagrant ssh`
    - `cd /vagrant/OpenDSA-LTI`
    - `bundle exec rake jobs:work`
4. Go to https://canvas.instructure.com/ and create a course with the name `OpenDSA-LTI`. Copy the course ID from the URL, you will use it later.
5. Go to https://192.168.33.10:9292 and login to the application with admin account (admin@opendsa.org, pass: 'adminadmin') and do the following:
    - Go to the admin area by clicking on the little wrench icon to the left of "admin@opendsa.org" in the top menu bar.
    - Under the `OpenDSA Books` menu, select `Book Instances`. Then click on `Upload Books` in the upper right corner. then  click `Choose File`, navigate to OpenDSA-DevStack/OpenDSA-LTI folder and choose `CS3_code-workout.json` and Click `Submit File`.
    - The configuration file will be imported as a template. Instructors can clone templates and link them to course offerings.

6. Logout and login again as instructor (example-1@railstutorial.org, pass: 'hokiehokie') and do the following:
    - Go to the admin area by clicking on the little wrench icon to the left of "example-1@railstutorial.org" in the top menu bar.
    - Click the `University-oriented` menu and select `Course Offerings`. There are six course offerings in three semesters, Spring-2016 (1/1-5/31), Summer-I (6/1-7/16), and Summer-II (7/16-8/16). Pick one and click `edit`. At the top of the form, select `https://canvas.instructure.com` from the menu. Also, modify `LMS COURSE CODE` to be 'OpenDSA-LTI' and `LMS COURSE NUM` to the course ID you copied in point #4 and hit `Update Course Offering` button.
    - Under the `OpenDSA Books` menu, select `Book Instances`. Clone the configuration file imported by the admin by clicking on clone option under Actions column.
    - Click edit option for the new cloned book configuration to link it to a course offering.
    - On `Book Instance` edit page, from the dropdown list select the course offering you linked to canvas course previously. Then hit `Update Inst Book` button.
    - Under the `LMS config` menu, click `LMS Access`. Create a new access to the Canvas instance and put your canvas access_token there. If you don't have Canvas access token follow the instructions [here](https://guides.instructure.com/m/4214/l/40399-how-do-i-obtain-an-api-access-token-for-an-account).
    - Click `Back to OpenDSA` link in the menu bar to go to main application page and compile the book.
    - Click the `Course` button and then click `browse all` to navigate to your selected course offering. Under the `OpenDSA` tab you will find the book linked to that offering. You can click `Configure Book` to go to book configuration view **(still under development)**. Click `Compile Book` button to generate the book's html files on the server file system, and send book details to the linked Canvas instance as well. You should see the progress bar moving forward while the course is being generated in Canvas.
    - Once the compilation process is complete, the book is available at your Canvas site. Go to Canvas and navigate to the "Modules" submenu for your course. You should see OpenDSA chapters created and published.
    - In OpenDSA sample book, under `1.1.Introduction to Data Structures and Algorithms` section you will find `Workout from Factory` assignment. Clicking on that assignment will load a programming assignment named `Workout from Factory` from CodeWorkout applicaiton through LTI protocol.

## Connect to Vagrant VM Database:

During development it is convenient to connect to `opendsa` and `codeworkout` databases from your host machine using [MySQL Workbench](https://www.mysql.com/products/workbench/). Once you installed MySQL Workbench create a new connection to Vagrant VM Database using the following setup:

- Connection Name: OpenDSA-Devstack
- Connection Method: Standard TCP/IP over SSH
- SSH Hostname: 192.168.33.10
- SSH Username: vagrant
- SSH Password: vagrant
- MySQL Hostname: 127.0.0.1
- MySQL Server Port: 3306
- Username: opendsa
- Password: opendsa
