Setting up the OpenDSA Development Environment (OpenDSA-DevStack)
=================================================================

## Instructions:

1. Install [Docker](https://docs.docker.com/get-docker/). If you experience any issues getting Docker set up, see our [Docker Troubleshooting](https://github.com/OpenDSA/OpenDSA-DevStack/tree/master#docker-issues) section below to debug.
2. Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
2. From a bash shell, clone this repostory (git clone https://github.com/OpenDSA/OpenDSA-DevStack.git).
3. From a bash shell at the root of OpenDSA-DevStack clone the repositories you will be working with into their correct relative locations: `docker-compose run setup make <<repository>>`
   - repository = [opendsa, opendsa-lti, code-workout]
4. From a bash shell at the root of OpenDSA-DevStack, Spin up your profile: See table below for command using Docker profiles, leave this command running in the shell
5. Go to your profile's URL in the [Table](https://github.com/OpenDSA/OpenDSA-DevStack/tree/master#OpenDSA-Projects)

### OpenDSA Projects:

| Repository                                             | Docker command                             | Profile's URL after `up` command              |
|--------------------------------------------------------|--------------------------------------------|-----------------------------------------------|
| [OpenDSA](https://github.com/OpenDSA/OpenDSA)          | `docker-compose --profile opendsa up`      | https://opendsa.localhost.devcom.vt.edu/      |
| [OpenDSA-LTI](https://github.com/OpenDSA/OpenDSA-LTI)  | `docker-compose --profile lti up`          | https://opendsa-lti.localhost.devcom.vt.edu/  |
| [CodeWorkout](https://github.com/web-cat/code-workout) | `docker-compose --profile code-workout up` | https://code-workout.localhost.devcom.vt.edu/ |

----------

### Navigating Projects and using Docker:

The `docker-compose.yml` file is how `docker` manages the many images and containers where your containers are running.  The `Dockerfile` is used by `docker` to create the image of a useful machine environment, which can produce containers to do the work.

- `docker-compose run <<container>> bash` allows you to create and `ssh` into container and have a shell and command line interface.
- `docker-compose --profile <<profile>> up` Creates new containers running the project according to a specified profile.  Meant for tasks that have no 'finish', like a server.
   - `docker-compose --profile <<profile>> down` to both stop and remove the containers that were brought up.
- `docker-compose run <<container>> <<commands>>`  starts a **new container** with a task than has a 'finish';  Some example commands are: `python test.py` or `bash`
   - `docker-compose exec <<container>> <<commands>>` to use a **running** container instead.
- If you are using code-workout and/or opendsa-lti, you should also initialize their databases with: `docker-compose exec opendsa-lti rake db:populate` or `docker-compose exec code-workout rake db:create db:populate`
- `docker-compose build <<containers>>` Builds a new image for containers (Note: old containers are **not** updated)
- `docker images` and `docker container list` displays the images/containers that are *currently active*.  Can add `--all` to see inactive ones as well.

### Useful tips and options:

- Adding the `--detach` or `-d` option allows some docker commands to run in the *background*, giving you back control of the command line.
- Setting a `docker-compose` alias is nice to avoid typing it as much.  We recommend `docc=docker-compose`
- On Windows, you may want to do `git config --global core.filemode false`.  Repositories cloned within Docker can show many changes to the file permissions when `git diff` is used outside of the Docker container.
- The `up` command can spin up several containers, e.g.: `docker-compose up opendsa opendsa-lti code-workout`
- There are also two specific profiles set up for common development stacks
  - `docker-compose --profile odsa-cw up` will bring up a stack including OpenDSA-LTI and CodeWorkout
  - `docker-compose --profile cw-op up` will bring up a stack including CodeWorkout and OpenPOP
- In the `docker-compose.yml` the `opendsa-lti` container has a few arguments that you can use to declare which branches of OpenDSA and OpenDSA-LTI you want to use

### Troubleshooting 
#### Docker Issues 
If you are having trouble building or running the OpenDSA Docker Images, first make sure that Docker itself is properly functioning. Before running any commands, ensure that the Docker Daemon is up and running and then run the command below in your terminal to pull a sample docker image. 

1. Pull the Docker Image: 
`docker pull shreyamallamula/dockernginx`
2. Run the Docker Image:
`docker run -d -p 5000:80 shreyamallamula/dockernginx`
3. In a browser, navigate to:
http://localhost:5000/ 

If you are not able to pull this image, reinstall Docker, or double check that you followed all the steps correctly. Some possible reasons Docker might not have installed correctly can be found below. 

#### Windows - Hyper-V 
If you are having trouble running Docker on a Windows 10 (or earlier) system, double check that Hyper-V is enabled. This setting might've been manually turned off in the past if you were running a Virtual Machine like VMWare in classes such as CS 2505/2506 . This setting should be automatically turned on by the Docker Desktop Windows Installer, but if a conflicting system (like VMWare is running) is still running, it needs to be manually checked. If you are actively running a conflicting system use the instructions found for Windows 11 instead. 

#### Windows 11
Docker on Windows was classically supported through Hyper-V, which no longer exists in Windows 11. Due to this, some manual shuffling of systems needs to be done to run Docker on these machines. The simplest approach seems to be to install a Linux Subsystem like WSL [Windows Subsystem for Linux](https://hope.edu/academics/computer-science/student-resources/using-wsl.html). After WSL is running, you should be able to download Docker, however you will still need to run Docker commands through an IDE that supports the Docker Platform. Many IDE's such as [IntelliJ](https://www.jetbrains.com/help/idea/docker.html#:~:text=IntelliJ%20IDEA%20provides%20Docker%20support,as%20described%20in%20Install%20plugins.) and [VSCode](https://code.visualstudio.com/docs/containers/overview) have plugins to support this, so use an IDE that you are comfortable with. After setting up the system, pull the sample docker image noted earlier in this section, to confirm success. 

#### Container sudo password:

When running commands in the container, there is not sudo password, (in case you need to execute any commands that require sudo).

#### Common Errors

Make sure that you have started Docker before running of the Makefile commands.

If you are on Windows, you may run into issues with line endings.  If you do, simply open Git Bash and run `$ dos2unix filename` to fix them.  This will most likely happen on a script file.

If you are on Windows, you may run into issues with any `docker exec` commands (such as `make ssh`).  To solve them, you may have to start any such command with `winpty`.

#### `opendsa` Database Test Data

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
  - `opendsa` database also includes the following accounts:
    - example-1@railstutorial.org (pass: hokiehokie), has instructor access
    - example-*@railstutorial.org (pass: hokiehokie) 50 students

    It also includes the following other objects:
    - Five terms (Spring, Summer I, Summer II, Fall, and Winter 2016),
    - one organization (VT)
    - one course (CS 1114)
    - two offerings of 1114 (one each term)
      - one course offering is set up with the admin and instructor
        as instructors, and all other sample accounts as students

#### Generate Canvas course using OpenDSA web interface.

1. After you are done you should have OpenDSA-LTI server running. Go to https://opendsa-lti.localhost.devcom.vt.edu to make sure your application is up and running.
2. Follow the instructions on the instructor's [guide page](https://opendsa-lti.localhost.devcom.vt.edu/home/guide) to set up your Canvas course. **Note:** skip the first step in this guide since you can use the **admin** account (admin@opendsa.org, pass: adminadmin) to cerate the course.

#### Connect to Docker Container Database:

During development, it is convenient to connect to the `opendsa` database from your host machine using [MySQL Workbench](https://www.mysql.com/products/workbench/). Once you installed MySQL Workbench create a new connection to Vagrant VM Database using the following setup:

- Connection Name: OpenDSA-Devstack
- Connection Method: Standard TCP/IP
- MySQL Hostname: 127.0.0.1
- MySQL Server Port: 3307
- Username: root
- Password: opendsa
