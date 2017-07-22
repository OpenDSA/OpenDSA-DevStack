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

The provisioning script will clone the OpenDSA, OpenDSA-LTI, and code-workout repositories inside the OpenDSA-DevStack directory. OpenDSA-DevStack directory is shared between your host machine and the virtual machine, so you can do your development to any of these repositories on your host machine using your preferred tools or IDEs (from "outside" the virtual machine). All changes you make will take effect immediately, and you can test them through the virtual machine server URLs provided earlier. You can commit and push your changes from your host machine. **However, if you want to compile books in OpenDSA, you have to do that from within the virtual machine.** Do so as follows:

1. Open a new terminal within your virtual machine
2. `$ cd OpenDSA-DevStack`
3. `$ vagrant ssh` (you don't need to do `vagrant up` if the VM is already up and running)
4. `$ cd /vagrant/OpenDSA`
5. `make <<CONFIG_FILE_NAME>>`

## Production deployment workflow

  - If you are responsible for OpenDSA-LTI production server, follow the instructions in this section to perform deployment on the production server.

  - Production deployment is initiated from the development environment. It starts with changes you make to OpenDSA-LTI or OpenDSA repositories in OpenDSA-DevStack. First, test these changes locally using OpenDSA-DevStack development servers. Second, commit and push OpenDSA-LTI and OpenDSA changes. Finally, initiate the production deployment command from within OpenDSA-DevStack. It is very important to push your changes before the deployment. Every time you deploy your code Capistrano will go and clone the latest version of OpenDSA-LTI then perform the deployment tasks. One of the tasks gets the latest version of OpenDSA from GitHub as well.

  - The following steps need to be done **only once** to generate a pair of authentication keys. **Note:** Do not enter a passphrase and replace **prod_server** with your domain name.
    <pre>
      <code>
    $ cd OpenDSA-DevStack
    $ vagrant up
    $ vagrant ssh
    $ ssh-keygen -t rsa
    $ cat .ssh/id_rsa.pub | ssh deploy@<b>prod_server</b> 'cat >> .ssh/authorized_keys'

    <b>Enter deploy user password for the last time</b>
      </code>
    </pre>

  - Here are the steps you need to follow every time you want to perform a production deployment:
    <pre>
      <code>
    $ cd OpenDSA-DevStack
    $ vagrant up
    $ vagrant ssh
    $ cd /vagrant/OpenDSA-LTI
    $ <b>git pull any new code</b>
    $ <b>commit and push any changes</b>
    Execute the following command to deploy to the <b>staging</b> server:
    $ bundle exec cap staging deploy
    Execute the following command to deploy to the <b>production</b> server:
    $ bundle exec cap production deploy
      </code>
    </pre>


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
3. Login using the admin account.
4. Go your institution's Canvas site or create an account at the public site
    at <a href="https://canvas.instructure.com">https://canvas.instructure.com</a> . Once there, create a course, 
    give it a name, and copy the course ID that you will find at the end of the course URL. You will use this ID later.
5. Go back to Go to OpenDSA application at https://192.168.33.10:9292, Click the "Course" button at the top of the page,
    then click "Create new course". 
    This will take you to a simple form that asks for the necessary
    information to define your course instance.
    Fill in all of the fields, and the click "Submit".
6. Once you have created your course offering, you will be redirected
    to the page where you can configure your eTextbook, and then
    generate the course in Canvas. Click the "Generate Course" button,
    and this process will take care of generating 
    modules, assignments, and assignments groups in Canvas.

## Connect to Vagrant VM Database:

During development, it is convenient to connect to `opendsa` and `codeworkout` databases from your host machine using [MySQL Workbench](https://www.mysql.com/products/workbench/). Once you installed MySQL Workbench create a new connection to Vagrant VM Database using the following setup:

- Connection Name: OpenDSA-Devstack
- Connection Method: Standard TCP/IP over SSH
- SSH Hostname: 192.168.33.10
- SSH Username: vagrant
- SSH Password: vagrant
- MySQL Hostname: 127.0.0.1
- MySQL Server Port: 3306
- Username: opendsa
- Password: opendsa


## Getting Chrome to accept Self Signed SSL for Local Development with Vagrant

- On the page with the untrusted certificate (`https://` is crossed out in red), click the lock > Certificate Information.
- Click the `Details tab > Export`. Choose `PKCS #7, single certificate` as the file format.
- Then follow my original instructions to get to the Manage Certificates page. Click the `Authorities tab > Import and choose the file to which you exported the certificate.
- If prompted certification store, choose Trusted Root Certificate Authorities
- Check all boxes and click OK. Restart Chrome.