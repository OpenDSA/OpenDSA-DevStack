Setting up the OpenDSA Development Environment (OpenDSA-DevStack)
=================================================================

## Instructions:

1. Install [Docker](https://docs.docker.com/get-docker/). If you experience any issues getting Docker set up, see our [Docker Troubleshooting](https://github.com/OpenDSA/OpenDSA-DevStack/blob/master/docs/common_errors.md) or if you are on windows, our [Windows Troubleshooting](https://github.com/OpenDSA/OpenDSA-DevStack/blob/master/docs/windows_troubleshooting.md) section to debug.
2. Install [Git](https://git-scm.com/book/en/v2/fGetting-Started-Installing-Git)
3. From a bash shell, clone this repostory: `git clone https://github.com/OpenDSA/OpenDSA-DevStack.git`.
4. From a bash shell at the root of OpenDSA-DevStack: `cp env.example .env`
   - If this command fails, you can create a new text file called example.env and copy in the contents of the .env file
6. From a bash shell at the root of OpenDSA-DevStack use docker compose to clone the repositories you will be working with into their correct relative locations: `docker-compose run setup make <<repository>>`
   - repository = [opendsa, opendsa-lti, code-workout]
7. To run all of the necessary container for different workflows we have created several docker profiles that combine them all into one command.
8. From a bash shell at the root of OpenDSA-DevStack, start your profile: See table below for command using Docker profiles, leave this command running in the shell
   - The first time this command is run it will pull the images and take up to 10 minutes to install. Subsequent times will take 1-2 minutes.
   - If you will be working on edits in the OpenDSA-LTI repo, you will want to build the Docker images locally (using a build command before an up command).
   - You will know the app is running when you see something like `=== puma startup: 2023-06-13 11:51:13 -0400 ===` as the last line in the terminal
9. Go to your profile's URL in the [Table](https://github.com/OpenDSA/OpenDSA-DevStack/tree/master#OpenDSA-Projects)

### OpenDSA Projects:

| Repository                                             | Docker command                             |Profile        | Profile's URL after `up` command              |
|--------------------------------------------------------|--------------------------------------------|---------------|-----------------------------------------------|
| [OpenDSA](https://github.com/OpenDSA/OpenDSA)          | `docker-compose --profile opendsa up`      |`opendsa`      | https://opendsa.localhost.devcom.vt.edu/      |
| [OpenDSA-LTI](https://github.com/OpenDSA/OpenDSA-LTI)  | `docker-compose --profile lti up`          |`lti`          | https://opendsa-lti.localhost.devcom.vt.edu/  |
| [CodeWorkout](https://github.com/web-cat/code-workout) | `docker-compose --profile code-workout up` |`code-workout` | https://code-workout.localhost.devcom.vt.edu/ |

----------

### Navigating Projects and using Docker:

The `docker-compose.yml` file is how `docker` manages the many images and containers where your containers are running.  The `Dockerfile` is used by `docker` to create the image of a useful machine environment, which can produce containers to do the work.

- `docker-compose run <<container>> bash` allows you to create and `ssh` into container to have a shell and command line interface.
- `docker-compose --profile <<profile>> up` Creates new containers running the project according to a specified profile.  Meant for tasks that have no 'finish', like a server.
   - `docker-compose --profile <<profile>> down` to both stop and remove the containers that were brought up.
- `docker-compose run <<container>> <<commands>>`  starts a **new container** with a task than has a 'finish';  Some example commands are: `python test.py` or `bash`
   - `docker-compose exec <<container>> <<commands>>` to use a **running** container instead.
- If you are using code-workout and/or opendsa-lti, you should also initialize their databases with: `docker-compose exec opendsa-lti rake db:populate` or `docker-compose exec code-workout rake db:create db:populate`
- `docker-compose build <<containers>>` Builds a new image for containers (Note: old containers are **not** updated)
- `docker images` and `docker container list` displays the images/containers that are *currently active*.  Can add `--all` to see inactive ones as well.

### Other Documentation

- See our [docs](https://github.com/OpenDSA/OpenDSA-DevStack/blob/master/docs/) folder for additional documentation
