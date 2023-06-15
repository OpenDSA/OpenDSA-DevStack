#### Updating the Docker Images

Periodically as we improve the platform and containers, users will need to pull new images for the opendsa containers. The steps are as follows:

1. Remove the currently running containers and images with `docker-compose --profile <<profile>> down`
2. Pull the updated version of the images with `docker-compose --profile <<profile>> pull`
3. Start up the server as you normally do with `docker-compose --profile <<profile>> up`
    - See the Readme for more details about starting Devstack
